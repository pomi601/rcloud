const std = @import("std");

fn r_build_step(
    b: *std.Build,
    libdir: *std.Build.Step.WriteFile,
    src: *std.Build.Dependency,
) *std.Build.Step.Run {
    const r_build = b.addSystemCommand(&.{"R"});
    r_build.addArgs(&.{
        "CMD",
        "INSTALL",
        "--no-docs",
        "--no-multiarch",
        "--no-staged-install",
        "-l",
    });
    r_build.addDirectoryArg(libdir.getDirectory());
    r_build.addDirectoryArg(src.path(""));
    r_build.setEnvironmentVariable("CC", "zig cc");
    r_build.setEnvironmentVariable("CXX", "zig c++");
    return r_build;
}

fn r_install_step(
    b: *std.Build,
    dep: *std.Build.Dependency,
    libdir: *std.Build.Step.WriteFile,
    name: []const u8,
) *std.Build.Step.InstallDir {
    const r_build = r_build_step(b, libdir, dep);
    const r_install = b.addInstallDirectory(.{
        .source_dir = libdir.getDirectory().path(b, name),
        .install_dir = .lib,
        .install_subdir = name,
    });
    r_install.step.dependOn(&r_build.step);
    return r_install;
}

pub fn build(b: *std.Build) !void {

    // the directory to which R libraries are installed during the
    // build step
    const r_libdir = b.addWriteFiles();

    const r_sys = r_install_step(
        b,
        b.dependency("r_sys", .{}),
        r_libdir,
        "sys",
    );

    const r_askpass = r_install_step(
        b,
        b.dependency("r_askpass", .{}),
        r_libdir,
        "askpass",
    );
    r_askpass.step.dependOn(&r_sys.step);

    b.getInstallStep().dependOn(&r_askpass.step);
    b.getInstallStep().dependOn(&r_sys.step);
}
