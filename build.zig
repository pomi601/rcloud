const std = @import("std");
const Build = std.Build;
const Step = Build.Step;
const Compile = Step.Compile;
const Run = Step.Run;
const UpdateSourceFiles = Step.UpdateSourceFiles;
const ResolvedTarget = Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

// import build tools from r_build_zig
const r_build_zig = @import("r-build-zig");

const generated_build = @import("build-aux/generated/build.zig");

fn b_fetch_assets_and_build(
    b: *Build,
    config_path: []const u8,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) !*Step {
    const exe = b.dependency("r-build-zig", .{
        .target = target,
        .optimize = optimize,
    }).artifact("fetch-assets");

    // arguments: config_file out_dir
    const step = b.addRunArtifact(exe);
    _ = step.addArg(config_path);
    const out_dir = step.addOutputDirectoryArg("assets");

    //

    try generated_build.build(b, out_dir);

    return &step.step;
}

fn b_generate_build(
    b: *Build,
    config_path: []const u8,
    updateStep: *Step,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) !void {
    const exe = b.dependency("r-build-zig", .{
        .target = target,
        .optimize = optimize,
    }).artifact("generate-build");

    // arguments: config_file out_dir package_dirs...
    const step = b.addRunArtifact(exe);
    _ = step.addArg(config_path);

    // by using a temp directory here, we ensure the results of this
    // step are never cached.
    // const out_dir = step.addOutputDirectoryArg(b.makeTempPath());
    const out_dir = step.addOutputDirectoryArg("deps");
    _ = step.addArg("packages");
    _ = step.addArg("rcloud.client");
    _ = step.addArg("rcloud.packages");
    _ = step.addArg("rcloud.support");

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

    const fetch = try b_fetch_assets_and_build(b, config_path, target, optimize);
    _ = fetch;

    // step: update
    try b_generate_build(b, config_path, update_step, target, optimize);
}
