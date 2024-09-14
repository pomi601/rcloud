const std = @import("std");
const rdepinfo = @import("rdepinfo");
const isBasePackage = rdepinfo.isBasePackage;
const isRecommendedPackage = rdepinfo.isRecommendedPackage;
const Repository = rdepinfo.Repository;
const NAVC = rdepinfo.NameAndVersionConstraint;
const NAVCHashMap = rdepinfo.NameAndVersionConstraintHashMap;
const NAVCHashMapSortContext = rdepinfo.NameAndVersionConstraintSortContext;

const downloadSlice = @import("./download_file.zig").downloadSlice;

const Config = struct {
    repos: []Repo,

    const Repo = struct {
        name: []const u8,
        url: []const u8,
    };
};

const ConfigRoot = struct {
    @"update-deps": Config,
};

/// Caller should supply an arena allocator as this parse will leak memory.
pub fn readConfig(alloc: std.mem.Allocator, path: []const u8) !Config {
    const config_file = try std.fs.cwd().openFile(path, .{});
    defer config_file.close();

    const buf = try config_file.readToEndAlloc(alloc, 128 * 1024);
    const root = try std.json.parseFromSliceLeaky(ConfigRoot, alloc, buf, .{
        .ignore_unknown_fields = true,
    });
    return root.@"update-deps";
}

/// Caller must deinit returned Repository.
fn readRepositories(alloc: std.mem.Allocator, repos: []Config.Repo) !Repository {
    var repository = try Repository.init(alloc);

    for (repos) |repo| {
        const url = try std.fmt.allocPrint(alloc, "{s}/src/contrib/PACKAGES.gz", .{repo.url});
        defer alloc.free(url);

        std.debug.print("Downloading {s}...\n", .{url});

        const data = try downloadSlice(alloc, url);
        defer alloc.free(data);

        var fbs = std.io.fixedBufferStream(data);
        const reader = fbs.reader();
        var buf = try std.ArrayList(u8).initCapacity(alloc, data.len * 3);
        defer buf.deinit();
        const writer = buf.writer();
        try std.compress.gzip.decompress(reader, writer);

        const text = try buf.toOwnedSlice();
        defer alloc.free(text);

        const n = try repository.read(repo.name, text);
        std.debug.print("    read {} packages from {s}\n", .{ n, repo.name });
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
    );

    try out_file.writeAll(
        \\}
    );
}

// pub fn add_package_step(b: *std.Build, descr: []const u8) !std.Build.Step {}

// pub fn build(b: *std.Build) !void {}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    defer std.process.argsFree(arena, args);

    // expect config_path out_path [package_dir...]
    if (args.len < 3) fatal("wrong number of arguments", .{});
    const config_path = args[1];
    const out_path = args[2];

    const config = readConfig(arena, config_path) catch |err| {
        fatal("could not read config file: '{s}': {s}\n", .{ config_path, @errorName(err) });
    };

    // download and read cloud repos
    var cloud_repositories = try readRepositories(arena, config.repos);
    defer cloud_repositories.deinit();
    var cloud_repositories_index = try cloud_repositories.createIndex();
    defer cloud_repositories_index.deinit();

    std.debug.print("{} packages read from cloud repositories.\n", .{cloud_repositories.packages.len});

    // construct package repo from directory arguments on command line
    var package_repo = try Repository.init(arena);
    defer package_repo.deinit();

    var i: usize = 3;
    while (i < args.len) : (i += 1) {
        var package_dir = std.fs.cwd().openDir(args[i], .{ .iterate = true }) catch |err| {
            fatal("could not open package directory '{s}': {s}\n", .{ args[i], @errorName(err) });
        };
        defer package_dir.close();

        try readPackagesIntoRepository(arena, &package_repo, package_dir);
        std.debug.print("read package directory '{s}'\n", .{args[i]});
    }

    std.debug.print("{} packages read from source directories.\n", .{package_repo.packages.len});

    // collect external dependencies
    var deps = NAVCHashMap.init(arena);
    defer deps.deinit();

    var it = package_repo.iter();
    while (it.next()) |p| {
        for (p.depends) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(arena, navc) == null) {
                try deps.put(navc, true);
            }
        }
        for (p.imports) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(arena, navc) == null) {
                try deps.put(navc, true);
            }
        }
        for (p.linkingTo) |navc| {
            if (isBasePackage(navc.name)) continue;
            if (isRecommendedPackage(navc.name)) continue;
            if (try package_repo.findLatestPackage(arena, navc) == null) {
                try deps.put(navc, true);
            }
        }
    }

    // print direct dependencies
    std.debug.print("\nDirect dependencies:\n", .{});
    for (deps.keys()) |navc| {
        std.debug.print("    {}\n", .{navc});
    }

    // collect their transitive dependencies
    const temp_keys = try arena.dupe(NAVC, deps.keys());
    defer arena.free(temp_keys);

    for (temp_keys) |navc| {
        const trans = cloud_repositories.transitiveDependenciesNoBase(arena, navc) catch |err| switch (err) {
            error.NotFound => {
                std.debug.print("skipping {s}: could not finish transitive dependencies.\n", .{navc.name});
                continue;
            },
            error.OutOfMemory => {
                fatal("out of memory.\n", .{});
            },
        };
        defer arena.free(trans);
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

    try write_build_file(out_path);
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
