const std = @import("std");

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

    const r_base64enc = r_install_step(
        b,
        b.dependency("r_base64enc", .{}),
        r_libdir,
        "base64enc",
    );

    const r_BH = r_install_step(
        b,
        b.dependency("r_bh", .{}),
        r_libdir,
        "bh",
    );

    const r_bitops = r_install_step(
        b,
        b.dependency("r_bitops", .{}),
        r_libdir,
        "bitops",
    );

    const r_brew = r_install_step(
        b,
        b.dependency("r_brew", .{}),
        r_libdir,
        "brew",
    );

    const r_Cairo = r_install_step(
        b,
        b.dependency("r_Cairo", .{}),
        r_libdir,
        "Cairo",
    );

    const r_cli = r_install_step(
        b,
        b.dependency("r_cli", .{}),
        r_libdir,
        "cli",
    );

    const r_commonmark = r_install_step(
        b,
        b.dependency("r_commonmark", .{}),
        r_libdir,
        "commonmark",
    );

    const r_curl = r_install_step(
        b,
        b.dependency("r_curl", .{}),
        r_libdir,
        "curl",
    );

    const r_digest = r_install_step(
        b,
        b.dependency("r_digest", .{}),
        r_libdir,
        "digest",
    );

    const r_evaluate = r_install_step(
        b,
        b.dependency("r_evaluate", .{}),
        r_libdir,
        "evaluate",
    );

    const r_fastmap = r_install_step(
        b,
        b.dependency("r_fastmap", .{}),
        r_libdir,
        "fastmap",
    );

    const r_FastRWeb = r_install_step(
        b,
        b.dependency("r_FastRWeb", .{}),
        r_libdir,
        "FastRWeb",
    );
    r_FastRWeb.step.dependOn(&r_base64enc.step);
    r_FastRWeb.step.dependOn(&r_Cairo.step);

    const r_fs = r_install_step(
        b,
        b.dependency("r_fs", .{}),
        r_libdir,
        "fs",
    );

    const r_glue = r_install_step(
        b,
        b.dependency("r_glue", .{}),
        r_libdir,
        "glue",
    );

    const r_jsonlite = r_install_step(
        b,
        b.dependency("r_jsonlite", .{}),
        r_libdir,
        "jsonlite",
    );

    const r_lattice = r_install_step(
        b,
        b.dependency("r_lattice", .{}),
        r_libdir,
        "lattice",
    );

    const r_magrittr = r_install_step(
        b,
        b.dependency("r_magrittr", .{}),
        r_libdir,
        "magrittr",
    );

    const r_markdown = r_install_step(
        b,
        b.dependency("r_markdown", .{}),
        r_libdir,
        "markdown",
    );
    r_markdown.step.dependOn(&r_commonmark.step);

    const r_Matrix = r_install_step(
        b,
        b.dependency("r_Matrix", .{}),
        r_libdir,
        "Matrix",
    );
    r_Matrix.step.dependOn(&r_lattice.step);

    const r_mime = r_install_step(
        b,
        b.dependency("r_mime", .{}),
        r_libdir,
        "mime",
    );

    const r_openssl = r_install_step(
        b,
        b.dependency("r_openssl", .{}),
        r_libdir,
        "openssl",
    );
    r_openssl.step.dependOn(&r_askpass.step);

    const r_png = r_install_step(
        b,
        b.dependency("r_png", .{}),
        r_libdir,
        "png",
    );

    const r_PKI = r_install_step(
        b,
        b.dependency("r_PKI", .{}),
        r_libdir,
        "PKI",
    );
    r_PKI.step.dependOn(&r_base64enc.step);

    const r_rappdirs = r_install_step(
        b,
        b.dependency("r_rappdirs", .{}),
        r_libdir,
        "rappdirs",
    );

    const r_Rcpp = r_install_step(
        b,
        b.dependency("r_Rcpp", .{}),
        r_libdir,
        "Rcpp",
    );

    const r_RcppTOML = r_install_step(
        b,
        b.dependency("r_RcppTOML", .{}),
        r_libdir,
        "RcppTOML",
    );
    r_RcppTOML.step.dependOn(&r_Rcpp.step);

    const r_RCurl = r_install_step(
        b,
        b.dependency("r_RCurl", .{}),
        r_libdir,
        "RCurl",
    );
    r_RCurl.step.dependOn(&r_bitops.step);

    const r_rlang = r_install_step(
        b,
        b.dependency("r_rlang", .{}),
        r_libdir,
        "rlang",
    );

    const r_lifecycle = r_install_step(
        b,
        b.dependency("r_lifecycle", .{}),
        r_libdir,
        "lifecycle",
    );
    r_lifecycle.step.dependOn(&r_cli.step);
    r_lifecycle.step.dependOn(&r_glue.step);
    r_lifecycle.step.dependOn(&r_rlang.step);

    const r_rprojroot = r_install_step(
        b,
        b.dependency("r_rprojroot", .{}),
        r_libdir,
        "rprojroot",
    );

    const r_here = r_install_step(
        b,
        b.dependency("r_here", .{}),
        r_libdir,
        "here",
    );
    r_here.step.dependOn(&r_rprojroot.step);

    const r_rjson = r_install_step(
        b,
        b.dependency("r_rjson", .{}),
        r_libdir,
        "rjson",
    );

    const r_Rook = r_install_step(
        b,
        b.dependency("r_Rook", .{}),
        r_libdir,
        "Rook",
    );
    r_Rook.step.dependOn(&r_brew.step);

    const r_RSclient = r_install_step(
        b,
        b.dependency("r_RSclient", .{}),
        r_libdir,
        "RSclient",
    );

    const r_Rserve = r_install_step(
        b,
        b.dependency("r_Rserve", .{}),
        r_libdir,
        "Rserve",
    );

    const r_R6 = r_install_step(
        b,
        b.dependency("r_R6", .{}),
        r_libdir,
        "R6",
    );

    const r_httr = r_install_step(
        b,
        b.dependency("r_httr", .{}),
        r_libdir,
        "httr",
    );
    r_httr.step.dependOn(&r_curl.step);
    r_httr.step.dependOn(&r_jsonlite.step);
    r_httr.step.dependOn(&r_mime.step);
    r_httr.step.dependOn(&r_openssl.step);
    r_httr.step.dependOn(&r_R6.step);

    const r_cachem = r_install_step(
        b,
        b.dependency("r_cachem", .{}),
        r_libdir,
        "cachem",
    );
    r_cachem.step.dependOn(&r_fastmap.step);
    r_cachem.step.dependOn(&r_rlang.step);

    const r_memoise = r_install_step(
        b,
        b.dependency("r_memoise", .{}),
        r_libdir,
        "memoise",
    );
    r_memoise.step.dependOn(&r_cachem.step);
    r_memoise.step.dependOn(&r_rlang.step);

    const r_sendmailR = r_install_step(
        b,
        b.dependency("r_sendmailR", .{}),
        r_libdir,
        "sendmailR",
    );
    r_sendmailR.step.dependOn(&r_base64enc.step);

    const r_stringi = r_install_step(
        b,
        b.dependency("r_stringi", .{}),
        r_libdir,
        "stringi",
    );

    const r_uuid = r_install_step(
        b,
        b.dependency("r_uuid", .{}),
        r_libdir,
        "uuid",
    );

    const r_vctrs = r_install_step(
        b,
        b.dependency("r_vctrs", .{}),
        r_libdir,
        "vctrs",
    );
    r_vctrs.step.dependOn(&r_cli.step);
    r_vctrs.step.dependOn(&r_glue.step);
    r_vctrs.step.dependOn(&r_lifecycle.step);
    r_vctrs.step.dependOn(&r_rlang.step);

    const r_stringr = r_install_step(
        b,
        b.dependency("r_stringr", .{}),
        r_libdir,
        "stringr",
    );
    r_stringr.step.dependOn(&r_cli.step);
    r_stringr.step.dependOn(&r_glue.step);
    r_stringr.step.dependOn(&r_lifecycle.step);
    r_stringr.step.dependOn(&r_magrittr.step);
    r_stringr.step.dependOn(&r_rlang.step);
    r_stringr.step.dependOn(&r_stringi.step);
    r_stringr.step.dependOn(&r_vctrs.step);

    const r_withr = r_install_step(
        b,
        b.dependency("r_withr", .{}),
        r_libdir,
        "withr",
    );

    const r_reticulate = r_install_step(
        b,
        b.dependency("r_reticulate", .{}),
        r_libdir,
        "reticulate",
    );
    r_reticulate.step.dependOn(&r_here.step);
    r_reticulate.step.dependOn(&r_jsonlite.step);
    r_reticulate.step.dependOn(&r_png.step);
    r_reticulate.step.dependOn(&r_rappdirs.step);
    r_reticulate.step.dependOn(&r_Matrix.step);
    r_reticulate.step.dependOn(&r_Rcpp.step);
    r_reticulate.step.dependOn(&r_RcppTOML.step);
    r_reticulate.step.dependOn(&r_rlang.step);
    r_reticulate.step.dependOn(&r_withr.step);

    const r_xfun = r_install_step(
        b,
        b.dependency("r_xfun", .{}),
        r_libdir,
        "xfun",
    );

    const r_tinytex = r_install_step(
        b,
        b.dependency("r_tinytex", .{}),
        r_libdir,
        "tinytex",
    );
    r_tinytex.step.dependOn(&r_xfun.step);

    const r_highr = r_install_step(
        b,
        b.dependency("r_highr", .{}),
        r_libdir,
        "highr",
    );
    r_highr.step.dependOn(&r_xfun.step);

    const r_yaml = r_install_step(
        b,
        b.dependency("r_yaml", .{}),
        r_libdir,
        "yaml",
    );

    const r_knitr = r_install_step(
        b,
        b.dependency("r_knitr", .{}),
        r_libdir,
        "knitr",
    );
    r_knitr.step.dependOn(&r_evaluate.step);
    r_knitr.step.dependOn(&r_highr.step);
    r_knitr.step.dependOn(&r_xfun.step);
    r_knitr.step.dependOn(&r_yaml.step);

    const r_htmltools = r_install_step(
        b,
        b.dependency("r_htmltools", .{}),
        r_libdir,
        "htmltools",
    );
    r_htmltools.step.dependOn(&r_base64enc.step);
    r_htmltools.step.dependOn(&r_digest.step);
    r_htmltools.step.dependOn(&r_fastmap.step);
    r_htmltools.step.dependOn(&r_knitr.step);
    r_htmltools.step.dependOn(&r_rlang.step);

    const r_sass = r_install_step(
        b,
        b.dependency("r_sass", .{}),
        r_libdir,
        "sass",
    );
    r_sass.step.dependOn(&r_fs.step);
    r_sass.step.dependOn(&r_htmltools.step);
    r_sass.step.dependOn(&r_R6.step);
    r_sass.step.dependOn(&r_rappdirs.step);
    r_sass.step.dependOn(&r_rlang.step);

    const r_fontawesome = r_install_step(
        b,
        b.dependency("r_fontawesome", .{}),
        r_libdir,
        "fontawesome",
    );
    r_fontawesome.step.dependOn(&r_htmltools.step);
    r_fontawesome.step.dependOn(&r_rlang.step);

    const r_jquerylib = r_install_step(
        b,
        b.dependency("r_jquerylib", .{}),
        r_libdir,
        "jquerylib",
    );
    r_jquerylib.step.dependOn(&r_htmltools.step);

    const r_bslib = r_install_step(
        b,
        b.dependency("r_bslib", .{}),
        r_libdir,
        "bslib",
    );
    r_bslib.step.dependOn(&r_base64enc.step);
    r_bslib.step.dependOn(&r_cachem.step);
    r_bslib.step.dependOn(&r_fastmap.step);
    r_bslib.step.dependOn(&r_htmltools.step);
    r_bslib.step.dependOn(&r_jquerylib.step);
    r_bslib.step.dependOn(&r_jsonlite.step);
    r_bslib.step.dependOn(&r_lifecycle.step);
    r_bslib.step.dependOn(&r_memoise.step);
    r_bslib.step.dependOn(&r_mime.step);
    r_bslib.step.dependOn(&r_rlang.step);
    r_bslib.step.dependOn(&r_sass.step);

    const r_rmarkdown = r_install_step(
        b,
        b.dependency("r_rmarkdown", .{}),
        r_libdir,
        "rmarkdown",
    );
    r_rmarkdown.step.dependOn(&r_bslib.step);
    r_rmarkdown.step.dependOn(&r_evaluate.step);
    r_rmarkdown.step.dependOn(&r_fontawesome.step);
    r_rmarkdown.step.dependOn(&r_htmltools.step);
    r_rmarkdown.step.dependOn(&r_jquerylib.step);
    r_rmarkdown.step.dependOn(&r_jsonlite.step);
    r_rmarkdown.step.dependOn(&r_knitr.step);
    r_rmarkdown.step.dependOn(&r_tinytex.step);
    r_rmarkdown.step.dependOn(&r_xfun.step);
    r_rmarkdown.step.dependOn(&r_yaml.step);

    //

    const r_guitar = r_install_step(
        b,
        b.dependency("r_guitar", .{}),
        r_libdir,
        "guitar",
    );
    r_guitar.step.dependOn(&r_Rcpp.step);
    r_guitar.step.dependOn(&r_BH.step);

    const r_github = r_install_step(
        b,
        b.dependency("r_github", .{}),
        r_libdir,
        "github",
    );
    r_github.step.dependOn(&r_httr.step);
    r_github.step.dependOn(&r_jsonlite.step);
    r_github.step.dependOn(&r_Rook.step);
    r_github.step.dependOn(&r_stringr.step);

    const r_rediscc = r_install_step(
        b,
        b.dependency("r_rediscc", .{}),
        r_libdir,
        "rediscc",
    );

    const r_unixtools = r_install_step(
        b,
        b.dependency("r_unixtools", .{}),
        r_libdir,
        "unixtools",
    );

    const r_ulog = r_install_step(
        b,
        b.dependency("r_ulog", .{}),
        r_libdir,
        "ulog",
    );

    // -------------------------------------------------------------
    //
    // END DEPENDENCIES
    //
    // -------------------------------------------------------------

    const rcloud_gist = r_install_step(
        b,
        b.dependency("rcloud_gist", .{}),
        r_libdir,
        "gist",
    );

    const rcloud_gitgist = r_install_step(
        b,
        b.dependency("rcloud_gitgist", .{}),
        r_libdir,
        "gitgist",
    );
    rcloud_gitgist.step.dependOn(&r_guitar.step);
    rcloud_gitgist.step.dependOn(&r_PKI.step);

    const rcloud_githubgist = r_install_step(
        b,
        b.dependency("rcloud_githubgist", .{}),
        r_libdir,
        "githubgist",
    );
    rcloud_githubgist.step.dependOn(&rcloud_gist.step);
    rcloud_githubgist.step.dependOn(&r_github.step);
    rcloud_githubgist.step.dependOn(&r_httr.step);

    const rcloud_client = r_install_step(
        b,
        b.dependency("rcloud_client", .{}),
        r_libdir,
        "rcloud.client",
    );
    rcloud_client.step.dependOn(&r_RSclient.step);
    rcloud_client.step.dependOn(&r_FastRWeb.step);

    const rcloud_support = r_install_step(
        b,
        b.dependency("rcloud_support", .{}),
        r_libdir,
        "rcloud.support",
    );
    rcloud_support.step.dependOn(&r_Cairo.step);
    rcloud_support.step.dependOn(&r_FastRWeb.step);
    rcloud_support.step.dependOn(&r_httr.step);
    rcloud_support.step.dependOn(&r_jsonlite.step);
    rcloud_support.step.dependOn(&r_knitr.step);
    rcloud_support.step.dependOn(&r_markdown.step);
    rcloud_support.step.dependOn(&r_mime.step);
    rcloud_support.step.dependOn(&r_PKI.step);
    rcloud_support.step.dependOn(&r_png.step);
    rcloud_support.step.dependOn(&r_RCurl.step);
    rcloud_support.step.dependOn(&r_Rserve.step);
    rcloud_support.step.dependOn(&r_rediscc.step);
    rcloud_support.step.dependOn(&r_rjson.step);
    rcloud_support.step.dependOn(&r_sendmailR.step);
    rcloud_support.step.dependOn(&r_unixtools.step);
    rcloud_support.step.dependOn(&r_uuid.step);
    rcloud_support.step.dependOn(&r_RSclient.step);
    rcloud_support.step.dependOn(&rcloud_client.step);
    rcloud_support.step.dependOn(&rcloud_gist.step);

    const r_rcloud_solr = r_install_step(
        b,
        b.dependency("r_rcloud_solr", .{}),
        r_libdir,
        "rcloud_solr",
    );
    r_rcloud_solr.step.dependOn(&r_rjson.step);
    r_rcloud_solr.step.dependOn(&rcloud_support.step);
    r_rcloud_solr.step.dependOn(&r_Rserve.step);
    r_rcloud_solr.step.dependOn(&r_httr.step);
    r_rcloud_solr.step.dependOn(&r_ulog.step);
    r_rcloud_solr.step.dependOn(&r_R6.step);

    //
    // Root installations
    //
    b.getInstallStep().dependOn(&rcloud_support.step);

    // for (rcloud_support.step.dependencies.items) |d| {
    //     std.debug.print("step: {s}\n", .{d.name});
    // }
}

fn r_build_step(
    b: *std.Build,
    libdir: *std.Build.Step.WriteFile,
    src: *std.Build.Dependency,
) *std.Build.Step.Run {
    const r_build = b.addSystemCommand(&.{"scripts/r-cmd-install.sh"});
    r_build.addArgs(&.{
        "--no-docs",
        "--no-multiarch",
        // "--no-staged-install",
        "-l",
    });
    r_build.addDirectoryArg(libdir.getDirectory());
    r_build.addDirectoryArg(src.path(""));
    r_build.setEnvironmentVariable("TMPDIR", "/tmp");

    // To experiment with replacing gcc with zig cc
    // r_build.setEnvironmentVariable("CC", "'zig cc'");
    // r_build.setEnvironmentVariable("CXX", "'zig c++'");
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
    r_install.step.name = name;
    return r_install;
}
