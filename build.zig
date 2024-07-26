const std = @import("std");

pub fn build(b: *std.Build) !void {

    // the directory to which R libraries are installed during the
    // build step
    const r_libdir = b.addWriteFiles();

    const r_sys = r_install_steps(
        b,
        b.dependency("r_sys", .{}),
        r_libdir,
        "sys",
    );
    // b.default_step.dependOn(&r_sys.build.step);

    const r_askpass = r_install_steps(
        b,
        b.dependency("r_askpass", .{}),
        r_libdir,
        "askpass",
    );
    r_askpass.build.step.dependOn(&r_sys.build.step);
    // b.default_step.dependOn(&r_askpass.step);

    const r_base64enc = r_install_steps(
        b,
        b.dependency("r_base64enc", .{}),
        r_libdir,
        "base64enc",
    );
    // b.default_step.dependOn(&r_base64enc.step);

    const r_BH = r_install_steps(
        b,
        b.dependency("r_bh", .{}),
        r_libdir,
        "bh",
    );
    // b.default_step.dependOn(&r_BH.step);

    const r_bitops = r_install_steps(
        b,
        b.dependency("r_bitops", .{}),
        r_libdir,
        "bitops",
    );
    // b.default_step.dependOn(&r_bitops.step);

    const r_brew = r_install_steps(
        b,
        b.dependency("r_brew", .{}),
        r_libdir,
        "brew",
    );
    // b.default_step.dependOn(&r_brew.step);

    const r_Cairo = r_install_steps(
        b,
        b.dependency("r_Cairo", .{}),
        r_libdir,
        "Cairo",
    );
    // b.default_step.dependOn(&r_Cairo.step);

    const r_cli = r_install_steps(
        b,
        b.dependency("r_cli", .{}),
        r_libdir,
        "cli",
    );
    // b.default_step.dependOn(&r_cli.step);

    const r_commonmark = r_install_steps(
        b,
        b.dependency("r_commonmark", .{}),
        r_libdir,
        "commonmark",
    );
    // b.default_step.dependOn(&r_commonmark.step);

    const r_curl = r_install_steps(
        b,
        b.dependency("r_curl", .{}),
        r_libdir,
        "curl",
    );
    // b.default_step.dependOn(&r_curl.step);

    const r_digest = r_install_steps(
        b,
        b.dependency("r_digest", .{}),
        r_libdir,
        "digest",
    );
    // b.default_step.dependOn(&r_digest.step);

    const r_evaluate = r_install_steps(
        b,
        b.dependency("r_evaluate", .{}),
        r_libdir,
        "evaluate",
    );
    // b.default_step.dependOn(&r_evaluate.step);

    const r_fastmap = r_install_steps(
        b,
        b.dependency("r_fastmap", .{}),
        r_libdir,
        "fastmap",
    );
    // b.default_step.dependOn(&r_fastmap.step);

    const r_FastRWeb = r_install_steps(
        b,
        b.dependency("r_FastRWeb", .{}),
        r_libdir,
        "FastRWeb",
    );
    r_FastRWeb.build.step.dependOn(&r_base64enc.build.step);
    r_FastRWeb.build.step.dependOn(&r_Cairo.build.step);
    // b.default_step.dependOn(&r_FastRWeb.step);

    const r_fs = r_install_steps(
        b,
        b.dependency("r_fs", .{}),
        r_libdir,
        "fs",
    );
    // b.default_step.dependOn(&r_fs.step);

    const r_glue = r_install_steps(
        b,
        b.dependency("r_glue", .{}),
        r_libdir,
        "glue",
    );
    // b.default_step.dependOn(&r_glue.step);

    const r_jsonlite = r_install_steps(
        b,
        b.dependency("r_jsonlite", .{}),
        r_libdir,
        "jsonlite",
    );
    // b.default_step.dependOn(&r_jsonlite.step);

    const r_lattice = r_install_steps(
        b,
        b.dependency("r_lattice", .{}),
        r_libdir,
        "lattice",
    );
    // b.default_step.dependOn(&r_lattice.step);

    const r_magrittr = r_install_steps(
        b,
        b.dependency("r_magrittr", .{}),
        r_libdir,
        "magrittr",
    );
    // b.default_step.dependOn(&r_magrittr.step);

    const r_markdown = r_install_steps(
        b,
        b.dependency("r_markdown", .{}),
        r_libdir,
        "markdown",
    );
    r_markdown.build.step.dependOn(&r_commonmark.build.step);
    // b.default_step.dependOn(&r_markdown.step);

    const r_Matrix = r_install_steps(
        b,
        b.dependency("r_Matrix", .{}),
        r_libdir,
        "Matrix",
    );
    r_Matrix.build.step.dependOn(&r_lattice.build.step);
    // b.default_step.dependOn(&r_Matrix.step);

    const r_mime = r_install_steps(
        b,
        b.dependency("r_mime", .{}),
        r_libdir,
        "mime",
    );
    // b.default_step.dependOn(&r_mime.step);

    const r_openssl = r_install_steps(
        b,
        b.dependency("r_openssl", .{}),
        r_libdir,
        "openssl",
    );
    r_openssl.build.step.dependOn(&r_askpass.build.step);
    // b.default_step.dependOn(&r_openssl.step);

    const r_png = r_install_steps(
        b,
        b.dependency("r_png", .{}),
        r_libdir,
        "png",
    );
    // b.default_step.dependOn(&r_png.step);

    const r_PKI = r_install_steps(
        b,
        b.dependency("r_PKI", .{}),
        r_libdir,
        "PKI",
    );
    r_PKI.build.step.dependOn(&r_base64enc.build.step);
    // b.default_step.dependOn(&r_PKI.step);

    const r_rappdirs = r_install_steps(
        b,
        b.dependency("r_rappdirs", .{}),
        r_libdir,
        "rappdirs",
    );
    // b.default_step.dependOn(&r_rappdirs.step);

    const r_Rcpp = r_install_steps(
        b,
        b.dependency("r_Rcpp", .{}),
        r_libdir,
        "Rcpp",
    );
    // b.default_step.dependOn(&r_Rcpp.step);

    const r_RcppTOML = r_install_steps(
        b,
        b.dependency("r_RcppTOML", .{}),
        r_libdir,
        "RcppTOML",
    );
    r_RcppTOML.build.step.dependOn(&r_Rcpp.build.step);
    // b.default_step.dependOn(&r_RcppTOML.step);

    const r_RCurl = r_install_steps(
        b,
        b.dependency("r_RCurl", .{}),
        r_libdir,
        "RCurl",
    );
    r_RCurl.build.step.dependOn(&r_bitops.build.step);
    // b.default_step.dependOn(&r_RCurl.step);

    const r_rlang = r_install_steps(
        b,
        b.dependency("r_rlang", .{}),
        r_libdir,
        "rlang",
    );
    // b.default_step.dependOn(&r_rlang.step);

    const r_lifecycle = r_install_steps(
        b,
        b.dependency("r_lifecycle", .{}),
        r_libdir,
        "lifecycle",
    );
    r_lifecycle.build.step.dependOn(&r_cli.build.step);
    r_lifecycle.build.step.dependOn(&r_glue.build.step);
    r_lifecycle.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_lifecycle.step);

    const r_rprojroot = r_install_steps(
        b,
        b.dependency("r_rprojroot", .{}),
        r_libdir,
        "rprojroot",
    );
    // b.default_step.dependOn(&r_rprojroot.step);

    const r_here = r_install_steps(
        b,
        b.dependency("r_here", .{}),
        r_libdir,
        "here",
    );
    r_here.build.step.dependOn(&r_rprojroot.build.step);
    // b.default_step.dependOn(&r_here.step);

    const r_rjson = r_install_steps(
        b,
        b.dependency("r_rjson", .{}),
        r_libdir,
        "rjson",
    );
    // b.default_step.dependOn(&r_rjson.step);

    const r_Rook = r_install_steps(
        b,
        b.dependency("r_Rook", .{}),
        r_libdir,
        "Rook",
    );
    r_Rook.build.step.dependOn(&r_brew.build.step);
    // b.default_step.dependOn(&r_Rook.step);

    const r_RSclient = r_install_steps(
        b,
        b.dependency("r_RSclient", .{}),
        r_libdir,
        "RSclient",
    );
    // b.default_step.dependOn(&r_RSclient.step);

    const r_Rserve = r_install_steps(
        b,
        b.dependency("r_Rserve", .{}),
        r_libdir,
        "Rserve",
    );
    // b.default_step.dependOn(&r_Rserve.step);

    const r_R6 = r_install_steps(
        b,
        b.dependency("r_R6", .{}),
        r_libdir,
        "R6",
    );
    // b.default_step.dependOn(&r_R6.step);

    const r_httr = r_install_steps(
        b,
        b.dependency("r_httr", .{}),
        r_libdir,
        "httr",
    );
    r_httr.build.step.dependOn(&r_curl.build.step);
    r_httr.build.step.dependOn(&r_jsonlite.build.step);
    r_httr.build.step.dependOn(&r_mime.build.step);
    r_httr.build.step.dependOn(&r_openssl.build.step);
    r_httr.build.step.dependOn(&r_R6.build.step);
    // b.default_step.dependOn(&r_httr.step);

    const r_cachem = r_install_steps(
        b,
        b.dependency("r_cachem", .{}),
        r_libdir,
        "cachem",
    );
    r_cachem.build.step.dependOn(&r_fastmap.build.step);
    r_cachem.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_cachem.step);

    const r_memoise = r_install_steps(
        b,
        b.dependency("r_memoise", .{}),
        r_libdir,
        "memoise",
    );
    r_memoise.build.step.dependOn(&r_cachem.build.step);
    r_memoise.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_memoise.step);

    const r_sendmailR = r_install_steps(
        b,
        b.dependency("r_sendmailR", .{}),
        r_libdir,
        "sendmailR",
    );
    r_sendmailR.build.step.dependOn(&r_base64enc.build.step);
    // b.default_step.dependOn(&r_sendmailR.step);

    const r_stringi = r_install_steps(
        b,
        b.dependency("r_stringi", .{}),
        r_libdir,
        "stringi",
    );
    // b.default_step.dependOn(&r_stringi.step);

    const r_uuid = r_install_steps(
        b,
        b.dependency("r_uuid", .{}),
        r_libdir,
        "uuid",
    );
    // b.default_step.dependOn(&r_uuid.step);

    const r_vctrs = r_install_steps(
        b,
        b.dependency("r_vctrs", .{}),
        r_libdir,
        "vctrs",
    );
    r_vctrs.build.step.dependOn(&r_cli.build.step);
    r_vctrs.build.step.dependOn(&r_glue.build.step);
    r_vctrs.build.step.dependOn(&r_lifecycle.build.step);
    r_vctrs.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_vctrs.step);

    const r_stringr = r_install_steps(
        b,
        b.dependency("r_stringr", .{}),
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
    // b.default_build.step.dependOn(&r_stringr.build.step);

    const r_withr = r_install_steps(
        b,
        b.dependency("r_withr", .{}),
        r_libdir,
        "withr",
    );
    // b.default_step.dependOn(&r_withr.step);

    const r_reticulate = r_install_steps(
        b,
        b.dependency("r_reticulate", .{}),
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
    // b.default_step.dependOn(&r_reticulate.step);

    const r_xfun = r_install_steps(
        b,
        b.dependency("r_xfun", .{}),
        r_libdir,
        "xfun",
    );
    // b.default_step.dependOn(&r_xfun.step);

    const r_tinytex = r_install_steps(
        b,
        b.dependency("r_tinytex", .{}),
        r_libdir,
        "tinytex",
    );
    r_tinytex.build.step.dependOn(&r_xfun.build.step);
    // b.default_step.dependOn(&r_tinytex.step);

    const r_highr = r_install_steps(
        b,
        b.dependency("r_highr", .{}),
        r_libdir,
        "highr",
    );
    r_highr.build.step.dependOn(&r_xfun.build.step);
    // b.default_step.dependOn(&r_highr.step);

    const r_yaml = r_install_steps(
        b,
        b.dependency("r_yaml", .{}),
        r_libdir,
        "yaml",
    );
    // b.default_step.dependOn(&r_yaml.step);

    const r_knitr = r_install_steps(
        b,
        b.dependency("r_knitr", .{}),
        r_libdir,
        "knitr",
    );
    r_knitr.build.step.dependOn(&r_evaluate.build.step);
    r_knitr.build.step.dependOn(&r_highr.build.step);
    r_knitr.build.step.dependOn(&r_xfun.build.step);
    r_knitr.build.step.dependOn(&r_yaml.build.step);
    // b.default_step.dependOn(&r_knitr.step);

    const r_htmltools = r_install_steps(
        b,
        b.dependency("r_htmltools", .{}),
        r_libdir,
        "htmltools",
    );
    r_htmltools.build.step.dependOn(&r_base64enc.build.step);
    r_htmltools.build.step.dependOn(&r_digest.build.step);
    r_htmltools.build.step.dependOn(&r_fastmap.build.step);
    r_htmltools.build.step.dependOn(&r_knitr.build.step);
    r_htmltools.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_htmltools.step);

    const r_sass = r_install_steps(
        b,
        b.dependency("r_sass", .{}),
        r_libdir,
        "sass",
    );
    r_sass.build.step.dependOn(&r_fs.build.step);
    r_sass.build.step.dependOn(&r_htmltools.build.step);
    r_sass.build.step.dependOn(&r_R6.build.step);
    r_sass.build.step.dependOn(&r_rappdirs.build.step);
    r_sass.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_sass.step);

    const r_fontawesome = r_install_steps(
        b,
        b.dependency("r_fontawesome", .{}),
        r_libdir,
        "fontawesome",
    );
    r_fontawesome.build.step.dependOn(&r_htmltools.build.step);
    r_fontawesome.build.step.dependOn(&r_rlang.build.step);
    // b.default_step.dependOn(&r_fontawesome.step);

    const r_jquerylib = r_install_steps(
        b,
        b.dependency("r_jquerylib", .{}),
        r_libdir,
        "jquerylib",
    );
    r_jquerylib.build.step.dependOn(&r_htmltools.build.step);
    // b.default_step.dependOn(&r_jquerylib.step);

    const r_bslib = r_install_steps(
        b,
        b.dependency("r_bslib", .{}),
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
    // b.default_step.dependOn(&r_bslib.step);

    const r_rmarkdown = r_install_steps(
        b,
        b.dependency("r_rmarkdown", .{}),
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
    // b.default_step.dependOn(&r_rmarkdown.step);

    //

    const r_guitar = r_install_steps(
        b,
        b.dependency("r_guitar", .{}),
        r_libdir,
        "guitar",
    );
    r_guitar.build.step.dependOn(&r_Rcpp.build.step);
    r_guitar.build.step.dependOn(&r_BH.build.step);
    // b.default_step.dependOn(&r_guitar.step);

    const r_github = r_install_steps(
        b,
        b.dependency("r_github", .{}),
        r_libdir,
        "github",
    );
    r_github.build.step.dependOn(&r_httr.build.step);
    r_github.build.step.dependOn(&r_jsonlite.build.step);
    r_github.build.step.dependOn(&r_Rook.build.step);
    r_github.build.step.dependOn(&r_stringr.build.step);
    // b.default_step.dependOn(&r_github.step);

    const r_rediscc = r_install_steps(
        b,
        b.dependency("r_rediscc", .{}),
        r_libdir,
        "rediscc",
    );
    // b.default_step.dependOn(&r_rediscc.step);

    const r_unixtools = r_install_steps(
        b,
        b.dependency("r_unixtools", .{}),
        r_libdir,
        "unixtools",
    );
    // b.default_step.dependOn(&r_unixtools.step);

    const r_ulog = r_install_steps(
        b,
        b.dependency("r_ulog", .{}),
        r_libdir,
        "ulog",
    );
    // b.default_step.dependOn(&r_ulog.step);

    // -------------------------------------------------------------
    //
    // END DEPENDENCIES
    //
    // -------------------------------------------------------------

    const rcloud_gist = r_install_steps(
        b,
        b.dependency("rcloud_gist", .{}),
        r_libdir,
        "gist",
    );
    // b.default_step.dependOn(&rcloud_gist.step);

    const rcloud_gitgist = r_install_steps(
        b,
        b.dependency("rcloud_gitgist", .{}),
        r_libdir,
        "gitgist",
    );
    rcloud_gitgist.build.step.dependOn(&r_guitar.build.step);
    rcloud_gitgist.build.step.dependOn(&r_PKI.build.step);
    // b.default_step.dependOn(&rcloud_gitgist.step);

    const rcloud_githubgist = r_install_steps(
        b,
        b.dependency("rcloud_githubgist", .{}),
        r_libdir,
        "githubgist",
    );
    rcloud_githubgist.build.step.dependOn(&rcloud_gist.build.step);
    rcloud_githubgist.build.step.dependOn(&r_github.build.step);
    rcloud_githubgist.build.step.dependOn(&r_httr.build.step);
    // b.default_step.dependOn(&rcloud_githubgist.step);

    const rcloud_client = r_install_steps(
        b,
        b.dependency("rcloud_client", .{}),
        r_libdir,
        "rcloud.client",
    );
    rcloud_client.build.step.dependOn(&r_RSclient.build.step);
    rcloud_client.build.step.dependOn(&r_FastRWeb.build.step);
    // b.default_step.dependOn(&rcloud_client.step);

    const rcloud_support = r_install_steps(
        b,
        b.dependency("rcloud_support", .{}),
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
    // b.default_step.dependOn(&rcloud_support.step);

    const r_rcloud_solr = r_install_steps(
        b,
        b.dependency("r_rcloud_solr", .{}),
        r_libdir,
        "rcloud_solr",
    );
    r_rcloud_solr.build.step.dependOn(&r_rjson.build.step);
    r_rcloud_solr.build.step.dependOn(&rcloud_support.build.step);
    r_rcloud_solr.build.step.dependOn(&r_Rserve.build.step);
    r_rcloud_solr.build.step.dependOn(&r_httr.build.step);
    r_rcloud_solr.build.step.dependOn(&r_ulog.build.step);
    r_rcloud_solr.build.step.dependOn(&r_R6.build.step);
    // b.default_step.dependOn(&r_rcloud_solr.step);

    //
    // Root installations
    //
    b.getInstallStep().dependOn(&rcloud_support.inst.step);

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
        // remove files created during previous runs, because FastRWeb
        // fails due to a mkdir without the -p option (directory
        // exists)
        "--clean",
        "--preclean",

        // don't bother building things we don't need
        "--no-docs",
        "--no-multiarch",
        // "--no-staged-install",
        "-l",
    });
    r_build.addDirectoryArg(libdir.getDirectory());
    r_build.addDirectoryArg(src.path(""));

    // To experiment with replacing gcc with zig cc
    // r_build.setEnvironmentVariable("CC", "'zig cc'");
    // r_build.setEnvironmentVariable("CXX", "'zig c++'");
    return r_build;
}

fn r_install_step_2(
    b: *std.Build,
    build_step: *std.Build.Step.Run,
    libdir: *std.Build.Step.WriteFile,
    name: []const u8,
) *std.Build.Step.InstallDir {
    const r_install = b.addInstallDirectory(.{
        .source_dir = libdir.getDirectory().path(b, name),
        .install_dir = .lib,
        .install_subdir = name,
    });
    r_install.step.dependOn(&build_step.step);
    r_install.step.name = name;
    return r_install;
}

fn r_install_steps(
    b: *std.Build,
    dep: *std.Build.Dependency,
    libdir: *std.Build.Step.WriteFile,
    name: []const u8,
) struct { build: *std.Build.Step.Run, inst: *std.Build.Step.InstallDir } {
    const r_build = r_build_step(b, libdir, dep);
    const r_install = b.addInstallDirectory(.{
        .source_dir = libdir.getDirectory().path(b, name),
        .install_dir = .lib,
        .install_subdir = name,
    });
    r_install.step.dependOn(&r_build.step);
    r_install.step.name = name;
    return .{ .build = r_build, .inst = r_install };
}
