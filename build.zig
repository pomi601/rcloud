const std = @import("std");
const Build = std.Build;
const Compile = std.Build.Step.Compile;
const Run = std.Build.Step.Run;
const ResolvedTarget = Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

// import build tools from rdepinfo
const rdepinfo = @import("rdepinfo");

// const update_deps = @import("build-aux/update_deps.zig");

fn b_fetch_assets(
    b: *Build,
    config_path: []const u8,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) void {
    const exe = b.dependency("rdepinfo", .{
        .target = target,
        .optimize = optimize,
    }).artifact("fetch-assets");

    // arguments: config_file out_dir
    const step = b.addRunArtifact(exe);
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

fn b_discover_dependencies(b: *Build, target: ResolvedTarget, optimize: OptimizeMode) !*Run {
    const exe = b.dependency("rdepinfo", .{
        .target = target,
        .optimize = optimize,
    }).artifact("discover-dependencies");

    // arguments: config_file out_dir package_dirs...
    const step = b.addRunArtifact(exe);
    _ = step.addArg(try b.build_root.join(b.allocator, &.{ "build-aux", "config.json" }));

    // by using a temp directory here, we ensure the results of this
    // step are never cached.
    _ = step.addOutputDirectoryArg(b.makeTempPath());
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"packages"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.client"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.packages"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.support"}));

    // return step;
    return step;
}

pub fn build(b: *std.Build) !void {
    // const buf: [std.mem.page_size]u8 = undefined;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const config_path = b.pathJoin(&.{ "build-aux", "config.json" });

    // steps
    const update_step = b.step("update", "Generate R package build files");

    b_fetch_assets(b, config_path, target, optimize);

    const update_deps = try b_discover_dependencies(b, target, optimize);
    update_step.dependOn(&update_deps.step);
}
