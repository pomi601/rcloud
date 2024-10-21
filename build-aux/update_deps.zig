const std = @import("std");
const rdepinfo = @import("rdepinfo");
const isBasePackage = rdepinfo.isBasePackage;
const isRecommendedPackage = rdepinfo.isRecommendedPackage;
const Repository = rdepinfo.Repository;
const NAVC = rdepinfo.version.NameAndVersionConstraint;
const NAVCHashMap = rdepinfo.version.NameAndVersionConstraintHashMap;
const NAVCHashMapSortContext = rdepinfo.version.NameAndVersionConstraintSortContext;

const download_file = @import("download_file.zig");
const hash_file = @import("hash_file.zig");

const downloadSlice = download_file.downloadSlice;

const Config = struct {
    repos: []Repo,

    const Repo = struct {
        name: []const u8,
        url: []const u8,
    };
};

const ConfigRoot = struct {
    @"update-deps": Config,
    assets: Assets,
};

const Assets = std.json.ArrayHashMap(OneAsset);
const OneAsset = struct {
    url: []const u8 = "",
    hash: []const u8 = "",
};

/// Caller should supply an arena allocator as this parse will leak memory.
pub fn readConfigRoot(alloc: std.mem.Allocator, path: []const u8) !ConfigRoot {
    const config_file = try std.fs.cwd().openFile(path, .{});
    defer config_file.close();

    const buf = try config_file.readToEndAlloc(alloc, 128 * 1024);
    const root = try std.json.parseFromSliceLeaky(ConfigRoot, alloc, buf, .{
        .ignore_unknown_fields = true,
    });
    return root;
}

/// Caller should supply an arena allocator as this parse will leak memory.
pub fn readConfig(alloc: std.mem.Allocator, path: []const u8) !Config {
    return (try readConfigRoot(alloc, path)).@"update-deps";
}

/// Caller should supply an arena allocator as this parse will leak memory.
pub fn readAssets(alloc: std.mem.Allocator, path: []const u8) !Assets {
    return (try readConfigRoot(alloc, path)).assets;
}

fn writeAssets(alloc: std.mem.Allocator, path: []const u8, assets: Assets) !void {
    var root = try readConfigRoot(alloc, path);

    root.assets = assets;

    const config_file = try std.fs.cwd().openFile(path, .{ .mode = .write_only });
    defer config_file.close();

    try std.json.stringify(root, .{ .whitespace = .indent_2 }, config_file.writer());
}

//

/// Caller must deinit returned Repository.
fn readRepositories(alloc: std.mem.Allocator, repos: []Config.Repo, tmp_path: []const u8) !Repository {
    var repository = try Repository.init(alloc);

    for (repos) |repo| {
        const url = try std.fmt.allocPrint(alloc, "{s}/src/contrib/PACKAGES.gz", .{repo.url});
        defer alloc.free(url);

        std.debug.print("Downloading {s}...\n", .{url});

        const path = try std.fs.path.join(alloc, &.{ tmp_path, "PACKAGES.gz" });
        std.debug.print("Saving to: {s}\n", .{path});
        try download_file.downloadFile(
            alloc,
            url,
            path,
        );

        const sz = (try std.fs.cwd().statFile(path)).size;
        std.debug.print("Downloaded {} bytes.\n", .{sz});

        var buf = try std.ArrayList(u8).initCapacity(
            alloc,
            sz * 3,
        );
        defer buf.deinit();

        {
            const file = try std.fs.cwd().openFile(path, .{});
            defer file.close();
            const reader = file.reader();
            const writer = buf.writer();
            try std.compress.gzip.decompress(reader, writer);
        }

        // const text = try buf.toOwnedSlice();
        // defer alloc.free(text);

        const n = try repository.read(repo.url, buf.items);
        std.debug.print("    read {} packages from {s}\n", .{ n, repo.name });

        try std.fs.cwd().deleteFile(path);
    }
    return repository;
}

/// Walk directory recursively and add all DESCRIPTION files to the given repository.
fn readPackagesIntoRepository(alloc: std.mem.Allocator, repository: *Repository, dir: std.fs.Dir) !void {
    var walker = try dir.walk(alloc);
    defer walker.deinit();

    while (try walker.next()) |d| {
        switch (d.kind) {
            .file => {
                if (std.mem.eql(u8, "DESCRIPTION", d.basename)) {
                    const file = try d.dir.openFile(d.basename, .{});
                    defer file.close();
                    const buf = try file.readToEndAlloc(alloc, 128 * 1024);
                    defer alloc.free(buf);

                    _ = try repository.read(d.path, buf);
                }
            },
            .directory => {
                var sub = try d.dir.openDir(d.basename, .{ .iterate = true });
                defer sub.close();
                try readPackagesIntoRepository(alloc, repository, sub);
            },
            else => continue,
        }
    }
}

fn write_build_file(path: []const u8) !void {
    var out_file = try std.fs.cwd().createFile(path, .{});
    defer out_file.close();

    try out_file.writeAll(
        \\const std = @import("std");
        \\pub fn build(b: *std.Build) !void {
        \\  const download_file = b.addExecutable(.{
        \\      .name = "download_file",
        \\      .root_source_file = b.path("build-aux/download_file.zig"),
        \\      .target = b.host,
        \\  });
        \\  _ = download_file;
        \\
        \\  const wf = b.addWriteFiles();
        \\
        \\  const config = try update_deps.readConfig(b.allocator, config_path);
        \\  _ = config;
        \\
        \\  // for (config.repos) |repo| {
        \\  //     const step = b.addRunArtifact(download_file);
        \\
        \\  //     _ = step.addArg(b.fmt("{s}/src/contrib/PACKAGES.gz", .{repo.url}));
        \\  //     const out = step.addOutputFileArg("PACKAGES.gz");
        \\
        \\  //     _ = wf.addCopyFile(out, b.fmt("{s}-PACKAGES.gz", .{repo.name}));
        \\  // }
        \\
        \\  b.getInstallStep().dependOn(&wf.step);
        \\
    );

    try out_file.writeAll(
        \\}
    );
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    var ts_alloc_state = std.heap.ThreadSafeAllocator{ .child_allocator = arena_state.allocator() };
    const alloc = ts_alloc_state.allocator();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    // expect workdir  tmpdir [package_dir...]
    if (args.len < 3) fatal("wrong number of arguments", .{});
    const work_path = args[1];
    const tmp_path = args[2];

    const config_path = try std.fs.path.join(alloc, &.{ work_path, "config.json" });
    const config = readConfig(alloc, config_path) catch |err| {
        fatal("could not read config file: '{s}': {s}\n", .{ config_path, @errorName(err) });
    };

    // download and read cloud repos
    var cloud_repositories = try readRepositories(alloc, config.repos, tmp_path);
    defer cloud_repositories.deinit();
    var cloud_repositories_index = try cloud_repositories.createIndex();
    defer cloud_repositories_index.deinit();

    std.debug.print("{} packages read from cloud repositories.\n", .{cloud_repositories.packages.len});

    // construct package repo from directory arguments on command line
    var package_repo = try Repository.init(alloc);
    defer package_repo.deinit();

    var i: usize = 3;
    while (i < args.len) : (i += 1) {
        var package_dir = std.fs.cwd().openDir(args[i], .{ .iterate = true }) catch |err| {
            fatal("could not open package directory '{s}': {s}\n", .{ args[i], @errorName(err) });
        };
        defer package_dir.close();

        try readPackagesIntoRepository(alloc, &package_repo, package_dir);
        std.debug.print("read package directory '{s}'\n", .{args[i]});
    }

    std.debug.print("{} packages read from source directories.\n", .{package_repo.packages.len});

    // collect external dependencies
    var deps = NAVCHashMap.init(alloc);
    defer deps.deinit();

    var it = package_repo.iter();
    while (it.next()) |p| {
        for (p.depends) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(alloc, navc) == null) {
                try deps.put(navc, true);
            }
        }
        for (p.imports) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(alloc, navc) == null) {
                try deps.put(navc, true);
            }
        }
        for (p.linkingTo) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(alloc, navc) == null) {
                try deps.put(navc, true);
            }
        }
    }

    // sort the hash map
    deps.sort(NAVCHashMapSortContext{ .keys = deps.keys() });

    // print direct dependencies
    std.debug.print("\nDirect dependencies:\n", .{});
    for (deps.keys()) |navc| {
        std.debug.print("    {}\n", .{navc});
    }

    // collect their transitive dependencies
    const temp_keys = try alloc.dupe(NAVC, deps.keys());
    defer alloc.free(temp_keys);

    for (temp_keys) |navc| {
        const trans = cloud_repositories.transitiveDependenciesNoBase(alloc, navc) catch |err| switch (err) {
            error.NotFound => {
                std.debug.print("skipping {s}: could not finish transitive dependencies.\n", .{navc.name});
                continue;
            },
            error.OutOfMemory => {
                fatal("out of memory.\n", .{});
            },
        };
        defer alloc.free(trans);
        for (trans) |x|
            try deps.put(x, true);
    }

    // sort the hash map
    deps.sort(NAVCHashMapSortContext{ .keys = deps.keys() });

    // print everything out
    std.debug.print("\nTransitive dependencies:\n", .{});
    for (deps.keys()) |navc| {
        std.debug.print("    {}\n", .{navc});
    }

    // merge version constraints
    const merged = try rdepinfo.version.mergeNameAndVersionConstraints(alloc, deps.keys());
    std.debug.print("\nMerged transitive dependencies:\n", .{});
    for (merged) |navc| {
        std.debug.print("    {}\n", .{navc});
    }

    // find the source
    var assets = Assets{};
    defer assets.deinit(alloc);

    var lock = std.Thread.Mutex{};

    var pool: std.Thread.Pool = undefined;
    try std.Thread.Pool.init(&pool, .{ .allocator = alloc });
    defer pool.deinit();

    var wg = std.Thread.WaitGroup{};

    for (merged) |navc| {
        const Op = struct {
            alloc: std.mem.Allocator,
            repo: *Repository,
            index: *Repository.Index,
            assets: *Assets,
            lock: *std.Thread.Mutex,

            pub fn op(self: @This(), nvc: NAVC) void {
                if (self.index.findPackage(nvc)) |found| {
                    const slice = self.repo.packages.slice();
                    const name = slice.items(.name)[found];
                    const repo = slice.items(.repository)[found];
                    const ver = slice.items(.version_string)[found];
                    const url1 = std.fmt.allocPrint(
                        self.alloc,
                        "{s}/src/contrib/{s}_{s}.tar.gz",
                        .{ repo, name, ver },
                    ) catch @panic("OOM");
                    const url2 = std.fmt.allocPrint(
                        self.alloc,
                        "{s}/src/contrib/Archive/{s}_{s}.tar.gz",
                        .{ repo, name, ver },
                    ) catch @panic("OOM");

                    if (download_file.headOk(self.alloc, url1) catch false) {
                        self.lock.lock();
                        defer self.lock.unlock();
                        self.assets.map.put(self.alloc, nvc.name, .{ .url = url1 }) catch @panic("OOM");
                    } else if (download_file.headOk(self.alloc, url2) catch false) {
                        self.lock.lock();
                        defer self.lock.unlock();
                        self.assets.map.put(self.alloc, nvc.name, .{ .url = url2 }) catch @panic("OOM");
                    } else {
                        fatal("NOT FOUND: {s}\nNOT FOUND: {s}\n", .{ url1, url2 });
                    }
                }
            }
        };
        const closure = Op{
            .alloc = alloc,
            .repo = &cloud_repositories,
            .index = &cloud_repositories_index,
            .assets = &assets,
            .lock = &lock,
        };
        pool.spawnWg(&wg, Op.op, .{ closure, navc });
    }
    pool.waitAndWork(&wg);

    {
        const C = struct {
            keys: []const []const u8,
            pub fn lessThan(ctx: @This(), a_index: usize, b_index: usize) bool {
                return std.mem.order(u8, ctx.keys[a_index], ctx.keys[b_index]) == .lt;
            }
        };
        assets.map.sort(C{ .keys = assets.map.keys() });
    }

    try writeAssets(alloc, config_path, assets);

    // try write_build_file(out_path);

    // TODO: delete temp directory before exiting on success
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
