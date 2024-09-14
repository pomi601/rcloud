const std = @import("std");

const update_deps = @import("build-aux/update_deps.zig");

pub fn build(b: *std.Build) !void {
    // const buf: [std.mem.page_size]u8 = undefined;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_path = b.pathJoin(&.{
        "build-aux",
        "config.json",
    });

    const update_step = b.step("update", "Generate R package build files");

    const download_file = b.addExecutable(.{
        .name = "download_file",
        .root_source_file = b.path("build-aux/download_file.zig"),
        .target = b.host,
    });
    _ = download_file;

    const wf = b.addWriteFiles();

    const config = try update_deps.readConfig(b.allocator, config_path);
    _ = config;

    // for (config.repos) |repo| {
    //     const step = b.addRunArtifact(download_file);

    //     _ = step.addArg(b.fmt("{s}/src/contrib/PACKAGES.gz", .{repo.url}));
    //     const out = step.addOutputFileArg("PACKAGES.gz");

    //     _ = wf.addCopyFile(out, b.fmt("{s}-PACKAGES.gz", .{repo.name}));
    // }

    b.getInstallStep().dependOn(&wf.step);

    //

    const update_build_deps = b.addExecutable(.{
        .name = "update_build_deps",
        .root_source_file = b.path("build-aux/update_deps.zig"),
        .target = b.host,
    });

    update_build_deps.root_module.addImport("rdepinfo", b.dependency(
        "rdepinfo",
        .{
            .target = target,
            .optimize = optimize,
        },
    ).module("rdepinfo"));

    {
        const step = b.addRunArtifact(update_build_deps);
        _ = step.addArg(config_path);
        const out = step.addOutputFileArg("build.zig");
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"packages"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.client"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.packages"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.support"}));

        // _ = step.addArg(b.path("packages").getPath3(b, &step.step));
        // _ = step.addArg(b.path("rcloud.client").getPath3(b, &step.step).sub_path(""));
        // _ = step.addArg(b.path("rcloud.packages").getPath3(b, &step.step).sub_path(""));
        // _ = step.addArg(b.path("rcloud.support").getPath3(b, &step.step).sub_path(""));

        const uf = b.addUpdateSourceFiles();
        uf.addCopyFileToSource(out, "build-aux/generated/build.zig");
        update_step.dependOn(&uf.step);
    }
}
