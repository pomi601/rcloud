const std = @import("std");

// import build tools from rdepinfo
const rdepinfo = @import("rdepinfo");

const update_deps = @import("build-aux/update_deps.zig");

pub fn build(b: *std.Build) !void {
    // const buf: [std.mem.page_size]u8 = undefined;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_path = b.pathJoin(&.{
        "build-aux",
        "config.json",
    });

    const fetch_assets = b.dependency("rdepinfo", .{
        .target = target,
        .optimize = optimize,
    }).artifact("fetch-assets");

    {
        // arguments: config_file out_dir
        const step = b.addRunArtifact(fetch_assets);
        _ = step.addArg(config_path);
        const out_dir = step.addOutputDirectoryArg("assets");

        // for now for testsing
        const install_step = b.addInstallDirectory(.{
            .source_dir = out_dir,
            .install_dir = .{ .custom = "assets" },
            .install_subdir = "",
        });
        b.getInstallStep().dependOn(&install_step.step);
    }

    //

    const update_step = b.step("update", "Generate R package build files");

    //

    const update_build_deps = b.addExecutable(.{
        .name = "update_build_deps",
        .root_source_file = b.path("build-aux/update_deps.zig"),
        .target = b.host,
        .optimize = .ReleaseFast,
    });

    update_build_deps.root_module.addImport("rdepinfo", b.dependency(
        "rdepinfo",
        .{
            .target = target,
            .optimize = optimize,
        },
    ).module("rdepinfo"));

    {
        // workdir tmpdir.
        // will access workdir/config.json.
        // will create workdir/generated/...
        const step = b.addRunArtifact(update_build_deps);
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"build-aux"}));
        _ = step.addArg(b.makeTempPath());
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"packages"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.client"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.packages"}));
        _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.support"}));

        // const out = step.addOutputFileArg("build.zig");

        // const uf = b.addUpdateSourceFiles();
        // uf.addCopyFileToSource(out, "build-aux/generated/build.zig");
        // update_step.dependOn(&uf.step);

        update_step.dependOn(&step.step);
    }
}
