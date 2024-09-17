const std = @import("std");
const Build = std.Build;
const Step = Build.Step;
const Compile = Step.Compile;
const Run = Step.Run;
const UpdateSourceFiles = Step.UpdateSourceFiles;
const ResolvedTarget = Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

// import build tools from rdepinfo
const rdepinfo = @import("rdepinfo");

const generated_build = @import("build-aux/generated/build.zig");

fn b_fetch_assets(
    b: *Build,
    config_path: []const u8,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) !*Step {
    const exe = b.dependency("rdepinfo", .{
        .target = target,
        .optimize = optimize,
    }).artifact("fetch-assets");

    // arguments: config_file out_dir
    const step = b.addRunArtifact(exe);
    _ = step.addArg(config_path);
    const out_dir = step.addOutputDirectoryArg("assets");

    // for now for testing
    const install_step = b.addInstallDirectory(.{
        .source_dir = out_dir,
        .install_dir = .{ .custom = "assets" },
        .install_subdir = "",
    });
    b.getInstallStep().dependOn(&install_step.step);

    //

    try generated_build.build(b, out_dir);

    return &install_step.step;
}

fn b_discover_dependencies(
    b: *Build,
    config_path: []const u8,
    updateStep: *Step,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) !void {
    const exe = b.dependency("rdepinfo", .{
        .target = target,
        .optimize = optimize,
    }).artifact("discover-dependencies");

    // arguments: config_file out_dir package_dirs...
    const step = b.addRunArtifact(exe);
    _ = step.addArg(config_path);

    // by using a temp directory here, we ensure the results of this
    // step are never cached.
    // const out_dir = step.addOutputDirectoryArg(b.makeTempPath());
    const out_dir = step.addOutputDirectoryArg("deps");
    _ = step.addOutputDirectoryArg("lib");

    _ = step.addArg(try b.build_root.join(b.allocator, &.{"packages"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.client"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.packages"}));
    _ = step.addArg(try b.build_root.join(b.allocator, &.{"rcloud.support"}));

    // copy the generated build.zig file to build-aux directory
    const uf = b.addUpdateSourceFiles();
    uf.addCopyFileToSource(out_dir.path(b, "build.zig"), "build-aux/generated/build.zig");

    updateStep.dependOn(&uf.step);
}

pub fn build(b: *std.Build) !void {
    // const buf: [std.mem.page_size]u8 = undefined;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const config_path = b.pathJoin(&.{ "build-aux", "config.json" });

    // steps
    const update_step = b.step("update", "Generate R package build files");

    const fetch = try b_fetch_assets(b, config_path, target, optimize);
    _ = fetch;

    // step: update
    try b_discover_dependencies(b, config_path, update_step, target, optimize);
}
