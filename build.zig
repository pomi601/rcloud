const std = @import("std");

pub fn build(b: *std.Build) !void {

    // the directory to which R libraries are installed during the
    // build step
    const r_libdir = b.addWriteFiles();

    const r_sys = r_install_steps(
        b,
        b.dependency("r_sys", .{}).path(""),
        r_libdir,
        "sys",
    );

    const r_askpass = r_install_steps(
        b,
        b.dependency("r_askpass", .{}).path(""),
        r_libdir,
        "askpass",
    );
    r_askpass.build.step.dependOn(&r_sys.build.step);

    const r_base64enc = r_install_steps(
        b,
        b.dependency("r_base64enc", .{}).path(""),
        r_libdir,
        "base64enc",
    );

    const r_BH = r_install_steps(
        b,
        b.dependency("r_bh", .{}).path(""),
        r_libdir,
        "bh",
    );

    const r_bitops = r_install_steps(
        b,
        b.dependency("r_bitops", .{}).path(""),
        r_libdir,
        "bitops",
    );

    const r_brew = r_install_steps(
        b,
        b.dependency("r_brew", .{}).path(""),
        r_libdir,
        "brew",
    );

    const r_Cairo = r_install_steps(
        b,
        b.dependency("r_Cairo", .{}).path(""),
        r_libdir,
        "Cairo",
    );

    const r_cli = r_install_steps(
        b,
        b.dependency("r_cli", .{}).path(""),
        r_libdir,
        "cli",
    );

    const r_commonmark = r_install_steps(
        b,
        b.dependency("r_commonmark", .{}).path(""),
        r_libdir,
        "commonmark",
    );

    const r_curl = r_install_steps(
        b,
        b.dependency("r_curl", .{}).path(""),
        r_libdir,
        "curl",
    );

    const r_digest = r_install_steps(
        b,
        b.dependency("r_digest", .{}).path(""),
        r_libdir,
        "digest",
    );

    const r_evaluate = r_install_steps(
        b,
        b.dependency("r_evaluate", .{}).path(""),
        r_libdir,
        "evaluate",
    );

    const r_fastmap = r_install_steps(
        b,
        b.dependency("r_fastmap", .{}).path(""),
        r_libdir,
        "fastmap",
    );

    const r_FastRWeb = r_install_steps(
        b,
        b.dependency("r_FastRWeb", .{}).path(""),
        r_libdir,
        "FastRWeb",
    );
    r_FastRWeb.build.step.dependOn(&r_base64enc.build.step);
    r_FastRWeb.build.step.dependOn(&r_Cairo.build.step);

    const r_fs = r_install_steps(
        b,
        b.dependency("r_fs", .{}).path(""),
        r_libdir,
        "fs",
    );

    const r_glue = r_install_steps(
        b,
        b.dependency("r_glue", .{}).path(""),
        r_libdir,
        "glue",
    );

    const r_jsonlite = r_install_steps(
        b,
        b.dependency("r_jsonlite", .{}).path(""),
        r_libdir,
        "jsonlite",
    );

    const r_lattice = r_install_steps(
        b,
        b.dependency("r_lattice", .{}).path(""),
        r_libdir,
        "lattice",
    );

    const r_magrittr = r_install_steps(
        b,
        b.dependency("r_magrittr", .{}).path(""),
        r_libdir,
        "magrittr",
    );

    const r_Matrix = r_install_steps(
        b,
        b.dependency("r_Matrix", .{}).path(""),
        r_libdir,
        "Matrix",
    );
    r_Matrix.build.step.dependOn(&r_lattice.build.step);

    const r_mime = r_install_steps(
        b,
        b.dependency("r_mime", .{}).path(""),
        r_libdir,
        "mime",
    );

    const r_openssl = r_install_steps(
        b,
        b.dependency("r_openssl", .{}).path(""),
        r_libdir,
        "openssl",
    );
    r_openssl.build.step.dependOn(&r_askpass.build.step);

    const r_png = r_install_steps(
        b,
        b.dependency("r_png", .{}).path(""),
        r_libdir,
        "png",
    );

    const r_PKI = r_install_steps(
        b,
        b.dependency("r_PKI", .{}).path(""),
        r_libdir,
        "PKI",
    );
    r_PKI.build.step.dependOn(&r_base64enc.build.step);

    const r_rappdirs = r_install_steps(
        b,
        b.dependency("r_rappdirs", .{}).path(""),
        r_libdir,
        "rappdirs",
    );

    const r_Rcpp = r_install_steps(
        b,
        b.dependency("r_Rcpp", .{}).path(""),
        r_libdir,
        "Rcpp",
    );

    const r_RcppTOML = r_install_steps(
        b,
        b.dependency("r_RcppTOML", .{}).path(""),
        r_libdir,
        "RcppTOML",
    );
    r_RcppTOML.build.step.dependOn(&r_Rcpp.build.step);

    const r_RCurl = r_install_steps(
        b,
        b.dependency("r_RCurl", .{}).path(""),
        r_libdir,
        "RCurl",
    );
    r_RCurl.build.step.dependOn(&r_bitops.build.step);

    const r_rlang = r_install_steps(
        b,
        b.dependency("r_rlang", .{}).path(""),
        r_libdir,
        "rlang",
    );

    const r_lifecycle = r_install_steps(
        b,
        b.dependency("r_lifecycle", .{}).path(""),
        r_libdir,
        "lifecycle",
    );
    r_lifecycle.build.step.dependOn(&r_cli.build.step);
    r_lifecycle.build.step.dependOn(&r_glue.build.step);
    r_lifecycle.build.step.dependOn(&r_rlang.build.step);

    const r_rprojroot = r_install_steps(
        b,
        b.dependency("r_rprojroot", .{}).path(""),
        r_libdir,
        "rprojroot",
    );

    const r_here = r_install_steps(
        b,
        b.dependency("r_here", .{}).path(""),
        r_libdir,
        "here",
    );
    r_here.build.step.dependOn(&r_rprojroot.build.step);

    const r_rjson = r_install_steps(
        b,
        b.dependency("r_rjson", .{}).path(""),
        r_libdir,
        "rjson",
    );

    const r_Rook = r_install_steps(
        b,
        b.dependency("r_Rook", .{}).path(""),
        r_libdir,
        "Rook",
    );
    r_Rook.build.step.dependOn(&r_brew.build.step);

    const r_RSclient = r_install_steps(
        b,
        b.dependency("r_RSclient", .{}).path(""),
        r_libdir,
        "RSclient",
    );

    const r_Rserve = r_install_steps(
        b,
        b.dependency("r_Rserve", .{}).path(""),
        r_libdir,
        "Rserve",
    );

    const r_R6 = r_install_steps(
        b,
        b.dependency("r_R6", .{}).path(""),
        r_libdir,
        "R6",
    );

    const r_httr = r_install_steps(
        b,
        b.dependency("r_httr", .{}).path(""),
        r_libdir,
        "httr",
    );
    r_httr.build.step.dependOn(&r_curl.build.step);
    r_httr.build.step.dependOn(&r_jsonlite.build.step);
    r_httr.build.step.dependOn(&r_mime.build.step);
    r_httr.build.step.dependOn(&r_openssl.build.step);
    r_httr.build.step.dependOn(&r_R6.build.step);

    const r_cachem = r_install_steps(
        b,
        b.dependency("r_cachem", .{}).path(""),
        r_libdir,
        "cachem",
    );
    r_cachem.build.step.dependOn(&r_fastmap.build.step);
    r_cachem.build.step.dependOn(&r_rlang.build.step);

    const r_memoise = r_install_steps(
        b,
        b.dependency("r_memoise", .{}).path(""),
        r_libdir,
        "memoise",
    );
    r_memoise.build.step.dependOn(&r_cachem.build.step);
    r_memoise.build.step.dependOn(&r_rlang.build.step);

    const r_sendmailR = r_install_steps(
        b,
        b.dependency("r_sendmailR", .{}).path(""),
        r_libdir,
        "sendmailR",
    );
    r_sendmailR.build.step.dependOn(&r_base64enc.build.step);

    const r_stringi = r_install_steps(
        b,
        b.dependency("r_stringi", .{}).path(""),
        r_libdir,
        "stringi",
    );

    const r_uuid = r_install_steps(
        b,
        b.dependency("r_uuid", .{}).path(""),
        r_libdir,
        "uuid",
    );

    const r_vctrs = r_install_steps(
        b,
        b.dependency("r_vctrs", .{}).path(""),
        r_libdir,
        "vctrs",
    );
    r_vctrs.build.step.dependOn(&r_cli.build.step);
    r_vctrs.build.step.dependOn(&r_glue.build.step);
    r_vctrs.build.step.dependOn(&r_lifecycle.build.step);
    r_vctrs.build.step.dependOn(&r_rlang.build.step);

    const r_stringr = r_install_steps(
        b,
        b.dependency("r_stringr", .{}).path(""),
        r_libdir,
        "stringr",
    );
    r_stringr.build.step.dependOn(&r_cli.build.step);
    r_stringr.build.step.dependOn(&r_glue.build.step);
    r_stringr.build.step.dependOn(&r_lifecycle.build.step);
    r_stringr.build.step.dependOn(&r_magrittr.build.step);
    r_stringr.build.step.dependOn(&r_rlang.build.step);
    r_stringr.build.step.dependOn(&r_stringi.build.step);
    r_stringr.build.step.dependOn(&r_vctrs.build.step);

    const r_withr = r_install_steps(
        b,
        b.dependency("r_withr", .{}).path(""),
        r_libdir,
        "withr",
    );

    const r_reticulate = r_install_steps(
        b,
        b.dependency("r_reticulate", .{}).path(""),
        r_libdir,
        "reticulate",
    );
    r_reticulate.build.step.dependOn(&r_here.build.step);
    r_reticulate.build.step.dependOn(&r_jsonlite.build.step);
    r_reticulate.build.step.dependOn(&r_png.build.step);
    r_reticulate.build.step.dependOn(&r_rappdirs.build.step);
    r_reticulate.build.step.dependOn(&r_Matrix.build.step);
    r_reticulate.build.step.dependOn(&r_Rcpp.build.step);
    r_reticulate.build.step.dependOn(&r_RcppTOML.build.step);
    r_reticulate.build.step.dependOn(&r_rlang.build.step);
    r_reticulate.build.step.dependOn(&r_withr.build.step);

    const r_xfun = r_install_steps(
        b,
        b.dependency("r_xfun", .{}).path(""),
        r_libdir,
        "xfun",
    );

    const r_markdown = r_install_steps(
        b,
        b.dependency("r_markdown", .{}).path(""),
        r_libdir,
        "markdown",
    );
    r_markdown.build.step.dependOn(&r_commonmark.build.step);
    r_markdown.build.step.dependOn(&r_xfun.build.step);

    const r_tinytex = r_install_steps(
        b,
        b.dependency("r_tinytex", .{}).path(""),
        r_libdir,
        "tinytex",
    );
    r_tinytex.build.step.dependOn(&r_xfun.build.step);

    const r_highr = r_install_steps(
        b,
        b.dependency("r_highr", .{}).path(""),
        r_libdir,
        "highr",
    );
    r_highr.build.step.dependOn(&r_xfun.build.step);

    const r_yaml = r_install_steps(
        b,
        b.dependency("r_yaml", .{}).path(""),
        r_libdir,
        "yaml",
    );

    const r_knitr = r_install_steps(
        b,
        b.dependency("r_knitr", .{}).path(""),
        r_libdir,
        "knitr",
    );
    r_knitr.build.step.dependOn(&r_evaluate.build.step);
    r_knitr.build.step.dependOn(&r_highr.build.step);
    r_knitr.build.step.dependOn(&r_xfun.build.step);
    r_knitr.build.step.dependOn(&r_yaml.build.step);

    const r_htmltools = r_install_steps(
        b,
        b.dependency("r_htmltools", .{}).path(""),
        r_libdir,
        "htmltools",
    );
    r_htmltools.build.step.dependOn(&r_base64enc.build.step);
    r_htmltools.build.step.dependOn(&r_digest.build.step);
    r_htmltools.build.step.dependOn(&r_fastmap.build.step);
    r_htmltools.build.step.dependOn(&r_knitr.build.step);
    r_htmltools.build.step.dependOn(&r_rlang.build.step);

    const r_sass = r_install_steps(
        b,
        b.dependency("r_sass", .{}).path(""),
        r_libdir,
        "sass",
    );
    r_sass.build.step.dependOn(&r_fs.build.step);
    r_sass.build.step.dependOn(&r_htmltools.build.step);
    r_sass.build.step.dependOn(&r_R6.build.step);
    r_sass.build.step.dependOn(&r_rappdirs.build.step);
    r_sass.build.step.dependOn(&r_rlang.build.step);

    const r_fontawesome = r_install_steps(
        b,
        b.dependency("r_fontawesome", .{}).path(""),
        r_libdir,
        "fontawesome",
    );
    r_fontawesome.build.step.dependOn(&r_htmltools.build.step);
    r_fontawesome.build.step.dependOn(&r_rlang.build.step);

    const r_jquerylib = r_install_steps(
        b,
        b.dependency("r_jquerylib", .{}).path(""),
        r_libdir,
        "jquerylib",
    );
    r_jquerylib.build.step.dependOn(&r_htmltools.build.step);

    const r_bslib = r_install_steps(
        b,
        b.dependency("r_bslib", .{}).path(""),
        r_libdir,
        "bslib",
    );
    r_bslib.build.step.dependOn(&r_base64enc.build.step);
    r_bslib.build.step.dependOn(&r_cachem.build.step);
    r_bslib.build.step.dependOn(&r_fastmap.build.step);
    r_bslib.build.step.dependOn(&r_htmltools.build.step);
    r_bslib.build.step.dependOn(&r_jquerylib.build.step);
    r_bslib.build.step.dependOn(&r_jsonlite.build.step);
    r_bslib.build.step.dependOn(&r_lifecycle.build.step);
    r_bslib.build.step.dependOn(&r_memoise.build.step);
    r_bslib.build.step.dependOn(&r_mime.build.step);
    r_bslib.build.step.dependOn(&r_rlang.build.step);
    r_bslib.build.step.dependOn(&r_sass.build.step);

    const r_rmarkdown = r_install_steps(
        b,
        b.dependency("r_rmarkdown", .{}).path(""),
        r_libdir,
        "rmarkdown",
    );
    r_rmarkdown.build.step.dependOn(&r_bslib.build.step);
    r_rmarkdown.build.step.dependOn(&r_evaluate.build.step);
    r_rmarkdown.build.step.dependOn(&r_fontawesome.build.step);
    r_rmarkdown.build.step.dependOn(&r_htmltools.build.step);
    r_rmarkdown.build.step.dependOn(&r_jquerylib.build.step);
    r_rmarkdown.build.step.dependOn(&r_jsonlite.build.step);
    r_rmarkdown.build.step.dependOn(&r_knitr.build.step);
    r_rmarkdown.build.step.dependOn(&r_tinytex.build.step);
    r_rmarkdown.build.step.dependOn(&r_xfun.build.step);
    r_rmarkdown.build.step.dependOn(&r_yaml.build.step);

    //

    const r_guitar = r_install_steps(
        b,
        b.dependency("r_guitar", .{}).path(""),
        r_libdir,
        "guitar",
    );
    r_guitar.build.step.dependOn(&r_Rcpp.build.step);
    r_guitar.build.step.dependOn(&r_BH.build.step);
    r_guitar.build.step.dependOn(&r_stringr.build.step);

    const r_github = r_install_steps(
        b,
        b.dependency("r_github", .{}).path(""),
        r_libdir,
        "github",
    );
    r_github.build.step.dependOn(&r_httr.build.step);
    r_github.build.step.dependOn(&r_jsonlite.build.step);
    r_github.build.step.dependOn(&r_Rook.build.step);
    r_github.build.step.dependOn(&r_stringr.build.step);

    const r_rediscc = r_install_steps(
        b,
        b.dependency("r_rediscc", .{}).path(""),
        r_libdir,
        "rediscc",
    );

    const r_unixtools = r_install_steps(
        b,
        b.dependency("r_unixtools", .{}).path(""),
        r_libdir,
        "unixtools",
    );

    const r_ulog = r_install_steps(
        b,
        b.dependency("r_ulog", .{}).path(""),
        r_libdir,
        "ulog",
    );

    // -------------------------------------------------------------
    //
    // END DEPENDENCIES
    //
    // -------------------------------------------------------------

    // FIXME: There is a bug in zig 0.13.0 which causes the cache to
    // become out of date with respect to the source directory when
    // using addCopyDirectory() vs addCopyFile(). This is corrected in
    // 0.14.0-dev.
    // TODO: remove this note when 0.14.0 is released.

    // To build our packages, first copy them into a cache directory,
    // because we don't want build artifacts to pollute our source
    // tree.

    const src_rcloud_gist = b.addWriteFiles();
    _ = src_rcloud_gist.addCopyDirectory(b.path("packages/gist"), ".", .{});
    const rcloud_gist = r_install_steps(
        b,
        src_rcloud_gist.getDirectory(),
        r_libdir,
        "gist",
    );

    const src_rcloud_gitgist = b.addWriteFiles();
    _ = src_rcloud_gitgist.addCopyDirectory(b.path("packages/gitgist"), "", .{});
    const rcloud_gitgist = r_install_steps(
        b,
        src_rcloud_gitgist.getDirectory(),
        r_libdir,
        "gitgist",
    );
    rcloud_gitgist.build.step.dependOn(&r_guitar.build.step);
    rcloud_gitgist.build.step.dependOn(&r_PKI.build.step);

    const src_rcloud_githubgist = b.addWriteFiles();
    _ = src_rcloud_githubgist.addCopyDirectory(b.path("packages/githubgist"), "", .{});
    const rcloud_githubgist = r_install_steps(
        b,
        src_rcloud_githubgist.getDirectory(),
        r_libdir,
        "githubgist",
    );
    rcloud_githubgist.build.step.dependOn(&rcloud_gist.build.step);
    rcloud_githubgist.build.step.dependOn(&r_github.build.step);
    rcloud_githubgist.build.step.dependOn(&r_httr.build.step);

    const src_rcloud_client = b.addWriteFiles();
    _ = src_rcloud_client.addCopyDirectory(b.path("./rcloud.client"), "", .{});
    const rcloud_client = r_install_steps(
        b,
        src_rcloud_client.getDirectory(),
        r_libdir,
        "rcloud.client",
    );
    rcloud_client.build.step.dependOn(&r_RSclient.build.step);
    rcloud_client.build.step.dependOn(&r_FastRWeb.build.step);

    const src_rcloud_support = b.addWriteFiles();
    _ = src_rcloud_support.addCopyDirectory(b.path("./rcloud.support"), "", .{});
    const rcloud_support = r_install_steps(
        b,
        src_rcloud_support.getDirectory(),
        r_libdir,
        "rcloud.support",
    );
    rcloud_support.build.step.dependOn(&r_Cairo.build.step);
    rcloud_support.build.step.dependOn(&r_FastRWeb.build.step);
    rcloud_support.build.step.dependOn(&r_httr.build.step);
    rcloud_support.build.step.dependOn(&r_jsonlite.build.step);
    rcloud_support.build.step.dependOn(&r_knitr.build.step);
    rcloud_support.build.step.dependOn(&r_markdown.build.step);
    rcloud_support.build.step.dependOn(&r_mime.build.step);
    rcloud_support.build.step.dependOn(&r_PKI.build.step);
    rcloud_support.build.step.dependOn(&r_png.build.step);
    rcloud_support.build.step.dependOn(&r_RCurl.build.step);
    rcloud_support.build.step.dependOn(&r_Rserve.build.step);
    rcloud_support.build.step.dependOn(&r_rediscc.build.step);
    rcloud_support.build.step.dependOn(&r_rjson.build.step);
    rcloud_support.build.step.dependOn(&r_sendmailR.build.step);
    rcloud_support.build.step.dependOn(&r_unixtools.build.step);
    rcloud_support.build.step.dependOn(&r_uuid.build.step);
    rcloud_support.build.step.dependOn(&r_RSclient.build.step);
    rcloud_support.build.step.dependOn(&rcloud_client.build.step);
    rcloud_support.build.step.dependOn(&rcloud_gist.build.step);

    const r_rcloud_solr = r_install_steps(
        b,
        b.dependency("r_rcloud_solr", .{}).path(""),
        r_libdir,
        "rcloud_solr",
    );
    r_rcloud_solr.build.step.dependOn(&r_rjson.build.step);
    r_rcloud_solr.build.step.dependOn(&rcloud_support.build.step);
    r_rcloud_solr.build.step.dependOn(&r_Rserve.build.step);
    r_rcloud_solr.build.step.dependOn(&r_httr.build.step);
    r_rcloud_solr.build.step.dependOn(&r_ulog.build.step);
    r_rcloud_solr.build.step.dependOn(&r_R6.build.step);

    //
    // INSTALLATION
    //
    // Copy r_libdir to $prefix
    //
    const install_libs = b.addInstallDirectory(.{
        .source_dir = r_libdir.getDirectory(),
        .install_dir = .prefix,
        .install_subdir = "lib",
    });
    b.getInstallStep().dependOn(&install_libs.step);

    //
    // ROOT of dependency graph
    //
    // Before we can install r_libdir, we have to build these packages
    // and all their dependencies.
    //
    install_libs.step.dependOn(&rcloud_support.stage.step);

    //
    // run command
    //
    const run_step = b.step("run", "Run it");
    run_step.dependOn(&install_libs.step);
}

/// Create a step which builds and stages the given src to libdir in
/// the .zig-cache.
fn r_build_step(
    b: *std.Build,
    libdir: *std.Build.Step.WriteFile,
    src: std.Build.LazyPath,
    name: []const u8,
) *std.Build.Step.Run {
    const r_build = b.addSystemCommand(&.{"scripts/r-cmd-install.sh"});
    r_build.addArgs(&.{
        // don't bother building things we don't need
        "--no-docs",
        "--no-multiarch",
        "-l",
    });
    r_build.addDirectoryArg(libdir.getDirectory());
    r_build.addDirectoryArg(src);

    r_build.step.name = name;

    return r_build;
}

/// Create staging and installation steps all in one go.
fn r_install_steps(
    b: *std.Build,
    src: std.Build.LazyPath,
    libdir: *std.Build.Step.WriteFile,
    name: []const u8,
) struct { build: *std.Build.Step.Run, stage: *std.Build.Step.InstallDir } {
    const r_build = r_build_step(b, libdir, src, name);

    const r_install = b.addInstallDirectory(.{
        .source_dir = libdir.getDirectory().path(b, name),
        .install_dir = .lib,
        .install_subdir = name,
    });

    r_install.step.dependOn(&r_build.step);
    r_install.step.name = name;
    return .{ .build = r_build, .stage = r_install };
}
