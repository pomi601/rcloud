const std = @import("std");

pub fn build(b: *std.Build) !void {
    // var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer _ = arena_state.deinit();
    // const arena = arena_state.allocator();

    // const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    const wf = b.addWriteFiles();

    // const r_build_lib_dir = b.path("out/lib");

    std.debug.print("b.exe_dir = {?s}\n", .{b.exe_dir});
    std.debug.print("b.lib_dir = {?s}\n", .{b.lib_dir});
    std.debug.print("b.dest_dir = {?s}\n", .{b.dest_dir});

    for (lib_tarballs) |tarball| {
        const r_build = b.addSystemCommand(&.{"R"});
        r_build.addArgs(&.{
            "CMD",
            "INSTALL",
            "--no-docs",
            "--no-multiarch",
            "--no-staged-install",
            "-l",
        });
        r_build.addDirectoryArg(wf.getDirectory());
        r_build.addFileArg(b.path(tarball));

        // figure out the path to the installed library
        const base = std.fs.path.basename(tarball);
        // split on _, which separates library name from its version
        var iter = std.mem.split(u8, base, "_");
        const lib_name = iter.next() orelse unreachable;

        const lib_generated = b.addWriteFiles();
        _ = lib_generated.add(b.fmt("zig-generated-{s}", .{
            lib_name,
        }), "now");
        lib_generated.step.dependOn(&r_build.step);

        // const lib_built_step = b.step(lib_name, "built the library");
        // lib_built_step.dependOn(&run.step);

        // add library build to default default step
        // b.default_step.dependOn(lib_built_step);

        // b.getInstallStep().dependOn(lib_built_step);

        const install_sys = b.addInstallDirectory(.{
            .source_dir = wf.getDirectory().path(b, lib_name),
            .install_dir = .lib,
            .install_subdir = lib_name,
        });
        install_sys.step.dependOn(&lib_generated.step);

        b.getInstallStep().dependOn(&install_sys.step);
    }

    // const path = try std.fs.path.join(arena, &.{ b.lib_dir, "sys" });
    // defer arena.free(path);

    // install_sys.step.dependOn(&r_build.step);

    // b.getInstallStep().dependOn(&b.addInstallDirectory(.{
    //     .source_dir = r_build_lib_dir.path(
    //         b,
    //         "sys",
    //     ),
    //     .install_dir = .lib,
    //     .install_subdir = "sys",
    // }).step);
}

const lib_tarballs = [_][]const u8{
    "build/out/dist/cran/sys_3.4.2.tar.gz",
};
