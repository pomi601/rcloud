const std = @import("std");

const update_deps = @import("build-aux/update_deps.zig");

pub fn build(b: *std.Build) !void {
    // const buf: [std.mem.page_size]u8 = undefined;
    // const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    const download_file = b.addExecutable(.{
        .name = "download_file",
        .root_source_file = b.path("build-aux/download_file.zig"),
        .target = b.host,
    });

    const wf = b.addWriteFiles();

    const config = try update_deps.read_config(b.allocator, b.pathJoin(&.{
        "build-aux",
        update_deps.config_path,
    }));

    for (config.repos) |repo| {
        const step = b.addRunArtifact(download_file);

        _ = step.addArg(b.fmt("{s}/src/contrib/PACKAGES.gz", .{repo.url}));
        const out = step.addOutputFileArg("PACKAGES.gz");

        _ = wf.addCopyFile(out, b.fmt("{s}-PACKAGES.gz", .{repo.name}));
    }

    b.getInstallStep().dependOn(&wf.step);
}
