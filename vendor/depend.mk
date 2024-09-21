# Packages available at CRAN
CRAN_PACKAGES := \
	askpass_1.2.0.tar.gz \
	base64enc_0.1-3.tar.gz \
	BH_1.84.0-0.tar.gz \
	bitops_1.0-7.tar.gz \
	brew_1.0-10.tar.gz \
	bslib_0.7.0.tar.gz \
	cachem_1.1.0.tar.gz \
	Cairo_1.6-2.tar.gz \
	cli_3.6.2.tar.gz \
	commonmark_1.9.1.tar.gz \
	curl_5.2.1.tar.gz \
	digest_0.6.35.tar.gz \
	evaluate_0.24.0.tar.gz \
	fastmap_1.2.0.tar.gz \
	FastRWeb_1.2-1.tar.gz \
	fontawesome_0.5.2.tar.gz \
	fs_1.6.4.tar.gz \
	glue_1.7.0.tar.gz \
	here_1.0.1.tar.gz \
	highr_0.11.tar.gz \
	htmltools_0.5.8.1.tar.gz \
	httr_1.4.7.tar.gz \
	jquerylib_0.1.4.tar.gz \
	knitr_1.47.tar.gz \
	jsonlite_1.8.8.tar.gz \
	lattice_0.22-6.tar.gz \
	lifecycle_1.0.4.tar.gz \
	magrittr_2.0.3.tar.gz \
	markdown_1.13.tar.gz \
	memoise_2.0.1.tar.gz \
	mime_0.12.tar.gz \
	openssl_2.2.0.tar.gz \
	png_0.1-8.tar.gz \
	PKI_0.1-14.tar.gz \
	rappdirs_0.3.3.tar.gz \
	Rcpp_1.0.12.tar.gz \
	RcppTOML_0.2.2.tar.gz \
	RCurl_1.98-1.14.tar.gz \
	reticulate_1.37.0.tar.gz \
	rlang_1.1.4.tar.gz \
	rmarkdown_2.27.tar.gz \
	rprojroot_2.0.4.tar.gz \
	rjson_0.2.21.tar.gz \
	Rook_1.2.tar.gz \
	RSclient_0.7-10.tar.gz \
	Rserve_1.8-13.tar.gz \
	R6_2.5.1.tar.gz \
	sass_0.4.9.tar.gz \
	sendmailR_1.4-0.tar.gz \
	stringi_1.8.4.tar.gz \
	stringr_1.5.1.tar.gz \
	sys_3.4.2.tar.gz \
	tinytex_0.51.tar.gz \
	uuid_1.2-0.tar.gz \
	vctrs_0.6.5.tar.gz \
	withr_3.0.0.tar.gz \
	xfun_0.45.tar.gz \
	yaml_2.3.8.tar.gz

# Packages available at RForge
RFORGE_PACKAGES := \
	guitar_0.0.3.1.tar.gz \
	github_0.9.12.tar.gz \
	rediscc_0.1-6.tar.gz \
	unixtools_0.1-1.tar.gz

# These packages depend on our internal package rcloud.support, so we
# create a separate installation target for them.
# NOTE: these must be listed in dependency order, not alphabetical.
# TODO: if these depend on rcloud.support, and rcloud.support is not
# available as an R package outside of this repository, then why are
# these two packages published on rforge and not a part of this repo?
RFORGE_PACKAGES_LATE := \
	ulog_0.1-2.tar.gz \
	rcloud.solr_0.3.8.tar.gz


OUT_DIR          = $(abs_top_builddir)/out
BUILD_DEP_DIR    = $(OUT_DIR)/lib
PKGS_DIR         = $(OUT_DIR)/pkgs
DIST             = $(OUT_DIR)/dist
SRC_DIST         = @srcdir@/dist
DIST_RFORGE      = $(DIST)/rforge
DIST_CRAN        = $(DIST)/cran
SRC_DIST_RFORGE  = $(SRC_DIST)/rforge
SRC_DIST_CRAN    = $(SRC_DIST)/cran
RFORGE_URL       = https://www.rforge.net/src/contrib
CRAN_URL         = https://cran.r-project.org/src/contrib
CRAN_ARCHIVE_URL = https://cran.r-project.org/src/contrib/Archive



DIST_CRAN_FILES        = $(addprefix $(DIST_CRAN)/,$(CRAN_PACKAGES))
DIST_RFORGE_FILES      = $(addprefix $(DIST_RFORGE)/,$(RFORGE_PACKAGES))
DIST_RFORGE_FILES_LATE = $(addprefix $(DIST_RFORGE)/,$(RFORGE_PACKAGES_LATE))

DIST_FILES                = $(DIST_CRAN_FILES) $(DIST_RFORGE_FILES)
DIST_FILES_LATE           = $(DIST_RFORGE_FILES_LATE)
DIST_CRAN_PACKAGES        = $(subst /,,$(dir $(subst _,/,$(patsubst %.tar.gz,%,$(CRAN_PACKAGES)))))
DIST_RFORGE_PACKAGES      = $(subst /,,$(dir $(subst _,/,$(patsubst %.tar.gz,%,$(RFORGE_PACKAGES)))))
DIST_RFORGE_PACKAGES_LATE = $(subst /,,$(dir $(subst _,/,$(patsubst %.tar.gz,%,$(RFORGE_PACKAGES_LATE)))))
# from inside to outside: foo_0.1.2.tar.gz -> foo_0.1.2 -> foo/0.1.2 -> foo/ -> foo

# build targets: package name is of the pattern foo.tar.gz
PKGS_CRAN            = $(addprefix $(PKGS_DIR)/,$(addsuffix .tar.gz,$(DIST_CRAN_PACKAGES)))
PKGS_RFORGE          = $(addprefix $(PKGS_DIR)/,$(addsuffix .tar.gz,$(DIST_RFORGE_PACKAGES)))
PKGS_RFORGE_LATE     = $(addprefix $(PKGS_DIR)/,$(addsuffix .tar.gz,$(DIST_RFORGE_PACKAGES_LATE)))
.SECONDARY: $(PKGS_CRAN) $(PKGS_RFORGE) $(PKGS_RFORGE_LATE)

# build_dep targets: package name is a directory
BUILD_DEP_CRAN         = $(addprefix $(BUILD_DEP_DIR)/,$(DIST_CRAN_PACKAGES))
BUILD_DEP_RFORGE       = $(addprefix $(BUILD_DEP_DIR)/,$(DIST_RFORGE_PACKAGES))
BUILD_DEP_RFORGE_LATE  = $(addprefix $(BUILD_DEP_DIR)/,$(DIST_RFORGE_PACKAGES_LATE))

# install targets: package name is a directory
INSTALL_CRAN         = $(addprefix $(R_SITE_LIB)/,$(DIST_CRAN_PACKAGES))
INSTALL_RFORGE       = $(addprefix $(R_SITE_LIB)/,$(DIST_RFORGE_PACKAGES))
INSTALL_RFORGE_LATE  = $(addprefix $(R_SITE_LIB)/,$(DIST_RFORGE_PACKAGES_LATE))
