SHELL = /bin/sh

OUT_DIR          = @abs_top_builddir@/out
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

WGET             = wget -q
R_SITE_LIB       = $(DESTDIR)@libdir@/rcloud/site-library
R_INSTALL        = R CMD INSTALL --no-docs -l $(R_SITE_LIB)
R_BUILD_DEP      = R_LIBS_USER=$(BUILD_DEP_DIR) R CMD INSTALL --no-docs -l $(BUILD_DEP_DIR)
R_BUILD          = R CMD INSTALL --no-docs --build --no-multiarch -l $(BUILD_DEP_DIR)

wget_verbose	= $(wget_verbose_@AM_V@)
wget_verbose_	= $(wget_verbose_@AM_DEFAULT_V@)
wget_verbose_0	= @echo "  WGET     $(@F)";

# For sub make
export R_SITE_LIB

# depend.mk defines CRAN_PACKAGES RFORGE_PACKAGES and RFORGE_PACKAGES_LAGE
include depend.mk

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

#
# vendor package dependencies, to get the build order right
#
$(PKGS_DIR)/askpass.tar.gz: \
	$(PKGS_DIR)/sys.tar.gz

$(PKGS_DIR)/FastRWeb.tar.gz: \
	$(PKGS_DIR)/base64enc.tar.gz \
	$(PKGS_DIR)/Cairo.tar.gz

$(PKGS_DIR)/openssl.tar.gz: \
	$(PKGS_DIR)/askpass.tar.gz

$(PKGS_DIR)/PKI.tar.gz: \
	$(PKGS_DIR)/base64enc.tar.gz

$(PKGS_DIR)/RcppTOML.tar.gz: \
	$(PKGS_DIR)/Rcpp.tar.gz

$(PKGS_DIR)/RCurl.tar.gz: \
	$(PKGS_DIR)/bitops.tar.gz

$(PKGS_DIR)/lifecycle.tar.gz: \
	$(PKGS_DIR)/cli.tar.gz \
	$(PKGS_DIR)/glue.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/here.tar.gz: \
	$(PKGS_DIR)/rprojroot.tar.gz

$(PKGS_DIR)/Rook.tar.gz: \
	$(PKGS_DIR)/brew.tar.gz

$(PKGS_DIR)/httr.tar.gz: \
	$(PKGS_DIR)/curl.tar.gz \
	$(PKGS_DIR)/jsonlite.tar.gz \
	$(PKGS_DIR)/mime.tar.gz \
	$(PKGS_DIR)/openssl.tar.gz \
	$(PKGS_DIR)/R6.tar.gz

$(PKGS_DIR)/cachem.tar.gz: \
	$(PKGS_DIR)/fastmap.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/memoise.tar.gz: \
	$(PKGS_DIR)/cachem.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/sendmailR.tar.gz: \
	$(PKGS_DIR)/base64enc.tar.gz

$(PKGS_DIR)/vctrs.tar.gz: \
	$(PKGS_DIR)/cli.tar.gz \
	$(PKGS_DIR)/glue.tar.gz \
	$(PKGS_DIR)/lifecycle.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/stringr.tar.gz: \
	$(PKGS_DIR)/cli.tar.gz \
	$(PKGS_DIR)/glue.tar.gz \
	$(PKGS_DIR)/lifecycle.tar.gz \
	$(PKGS_DIR)/magrittr.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz \
	$(PKGS_DIR)/stringi.tar.gz \
	$(PKGS_DIR)/vctrs.tar.gz

$(PKGS_DIR)/reticulate.tar.gz: \
	$(PKGS_DIR)/here.tar.gz \
	$(PKGS_DIR)/jsonlite.tar.gz \
	$(PKGS_DIR)/png.tar.gz \
	$(PKGS_DIR)/rappdirs.tar.gz \
	$(PKGS_DIR)/Rcpp.tar.gz \
	$(PKGS_DIR)/RcppTOML.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz \
	$(PKGS_DIR)/withr.tar.gz

$(PKGS_DIR)/markdown.tar.gz: \
	$(PKGS_DIR)/commonmark.tar.gz \
	$(PKGS_DIR)/xfun.tar.gz

$(PKGS_DIR)/tinytex.tar.gz: \
	$(PKGS_DIR)/xfun.tar.gz

$(PKGS_DIR)/highr.tar.gz: \
	$(PKGS_DIR)/xfun.tar.gz

$(PKGS_DIR)/knitr.tar.gz: \
	$(PKGS_DIR)/evaluate.tar.gz \
	$(PKGS_DIR)/highr.tar.gz \
	$(PKGS_DIR)/xfun.tar.gz \
	$(PKGS_DIR)/yaml.tar.gz

$(PKGS_DIR)/htmltools.tar.gz: \
	$(PKGS_DIR)/base64enc.tar.gz \
	$(PKGS_DIR)/digest.tar.gz \
	$(PKGS_DIR)/fastmap.tar.gz \
	$(PKGS_DIR)/knitr.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/sass.tar.gz: \
	$(PKGS_DIR)/fs.tar.gz \
	$(PKGS_DIR)/htmltools.tar.gz \
	$(PKGS_DIR)/R6.tar.gz \
	$(PKGS_DIR)/rappdirs.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/fontawesome.tar.gz: \
	$(PKGS_DIR)/htmltools.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz

$(PKGS_DIR)/jquerylib.tar.gz: \
	$(PKGS_DIR)/htmltools.tar.gz

$(PKGS_DIR)/bslib.tar.gz: \
	$(PKGS_DIR)/base64enc.tar.gz \
	$(PKGS_DIR)/cachem.tar.gz \
	$(PKGS_DIR)/fastmap.tar.gz \
	$(PKGS_DIR)/htmltools.tar.gz \
	$(PKGS_DIR)/jquerylib.tar.gz \
	$(PKGS_DIR)/jsonlite.tar.gz \
	$(PKGS_DIR)/lifecycle.tar.gz \
	$(PKGS_DIR)/memoise.tar.gz \
	$(PKGS_DIR)/mime.tar.gz \
	$(PKGS_DIR)/rlang.tar.gz \
	$(PKGS_DIR)/sass.tar.gz

$(PKGS_DIR)/rmarkdown.tar.gz: \
	$(PKGS_DIR)/bslib.tar.gz \
	$(PKGS_DIR)/evaluate.tar.gz \
	$(PKGS_DIR)/fontawesome.tar.gz \
	$(PKGS_DIR)/htmltools.tar.gz \
	$(PKGS_DIR)/jquerylib.tar.gz \
	$(PKGS_DIR)/jsonlite.tar.gz \
	$(PKGS_DIR)/knitr.tar.gz \
	$(PKGS_DIR)/tinytex.tar.gz \
	$(PKGS_DIR)/xfun.tar.gz \
	$(PKGS_DIR)/yaml.tar.gz

$(PKGS_DIR)/guitar.tar.gz: \
	$(PKGS_DIR)/Rcpp.tar.gz \
	$(PKGS_DIR)/BH.tar.gz \
	$(PKGS_DIR)/stringr.tar.gz

$(PKGS_DIR)/github.tar.gz: \
	$(PKGS_DIR)/httr.tar.gz \
	$(PKGS_DIR)/jsonlite.tar.gz \
	$(PKGS_DIR)/Rook.tar.gz \
	$(PKGS_DIR)/stringr.tar.gz


#
# Building binary packages
#
# We treat these vendored dependencies as if they were static
# libraries that need to be built prior to our own source code. So we
# want to build binary packages and install them to a build output
# directory, for use by our own source code when we get around to
# building it. This is the BUILD_DEP_DIR directory.
#
# Due to dependencies between the vendored libraries, we need to
# attempt to installed each package multiple times. Eventually, its
# dependencies will have successfully built, and it will succeed.
#
# The build process uses R CMD INSTALL --build to generate a binary
# package, then strips off the version and platfrom info to standardise
# the package filenames. It then installs them to BUILD_DEP_DIR.
#
# Since R CMD INSTALL does not provide a way to redirect its generated
# output, we have to assume a particular naming convention in order to
# find the output file.
#
$(PKGS_DIR)/%.tar.gz:
	$(AM_V_GEN) STEM=$(basename $(basename $(@F))) \
	&& SOURCEDIST=$${STEM}_*.tar.gz \
	&& if [ -e $(DIST_CRAN)/$${SOURCEDIST} ]; then \
	  $(R_BUILD) $(DIST_CRAN)/$${SOURCEDIST} > $(@F).log 2>&1; \
	elif [ -e $(DIST_RFORGE)/$${SOURCEDIST} ]; then \
	  $(R_BUILD) $(DIST_RFORGE)/$${SOURCEDIST} > $(@F).log 2>&1; \
	else \
	  echo "ERROR: can't find $${SOURCEDIST} anywhere..."; \
	  exit 1; \
	fi \
	&& TARBALL=$${STEM}_*_R_$(build).tar.gz \
	&& mv $${TARBALL} $(PKGS_DIR)/$${STEM}.tar.gz \
	|| echo "  DEFER    $@"

# NOTE: need to touch the target directory after successful install,
# because otherwise the tarball may have a newer timestamp (which I
# observed)
$(BUILD_DEP_DIR)/%: $(PKGS_DIR)/%.tar.gz
	$(AM_V_GEN) $(R_BUILD_DEP) $< > /dev/null 2>&1


# This target supplements automake's `all' target. It recursively
# makes the `do-all-local` target multiple times as described in the
# `Building binary packages` section above.
# TODO: multiple iterations are no longer needed since we've added all
# the inter-package dependency rules.
all-local: | vendor-fetch-local $(DIST_FILES) check-sums $(PKGS_DIR) $(BUILD_DEP_DIR)
	$(MAKE) $(AM_MAKEFLAGS) --ignore-errors --keep-going do-all-local 2> /dev/null;


# These targets are for the repeated recursive make.
do-all-local: | $(BUILD_DEP_CRAN) $(BUILD_DEP_RFORGE)

late-local: $(BUILD_DEP_RFORGE_LATE)


#
# Installation
#
# Install to ${prefix}/lib/rcloud/site-library
#

$(R_SITE_LIB)/%: $(PKGS_DIR)/%.tar.gz | $(R_SITE_LIB)
	$(AM_V_GEN) $(R_INSTALL) $< > /dev/null 2>&1

# This target is used by dockerfile and install-exec-local
vendor-install-local: | $(INSTALL_CRAN) $(INSTALL_RFORGE) $(INSTALL_RFORGE_LATE)


#
# Dist files
#
# vendor-fetch: fetches all dependencies' tarballs
#
# vendor-copy: copies fetched tarballs back to source directory to
#              avoid repeated downloads after make distclean or using a
#              new build directory
#
# generate-checksums: unconditionally generate new checksums.txt files
#                     for all .tar.gz files in both cran and rforge
#                     directories
#
# check-sums: exit 1 if there is a checksum mismatch
#

.PHONY: $(DIST_CRAN)
$(DIST_CRAN):
	$(MKDIR_P) $(DIST_CRAN)
	-cp -rp $(SRC_DIST_CRAN)/* $(DIST_CRAN)/

.PHONY: $(DIST_RFORGE)
$(DIST_RFORGE):
	$(MKDIR_P) $(DIST_RFORGE)
	-cp -rp $(SRC_DIST_RFORGE)/* $(DIST_RFORGE)/

vendor-fetch-local: | $(DIST_CRAN) $(DIST_RFORGE)
	$(MAKE) $(AM_MAKEFLAGS) do-vendor-fetch

do-vendor-fetch: $(DIST_FILES) $(DIST_FILES_LATE)

$(DIST_CRAN)/%.tar.gz:
	$(wget_verbose)$(WGET) -O $@ $(CRAN_URL)/$(@F) || \
	$(WGET) -O $@ $(CRAN_ARCHIVE_URL)/$(subst /,,$(dir $(subst _,/,$(patsubst %.tar.gz,%,$(@F)))))/$(@F)

$(DIST_RFORGE)/%.tar.gz:
	$(wget_verbose)$(WGET) -O $@ $(RFORGE_URL)/$(@F)


.PHONY: vendor-copy-local
vendor-copy-local:
	$(MKDIR_P) $(SRC_DIST_CRAN)
	$(MKDIR_P) $(SRC_DIST_RFORGE)
	cp -rp $(DIST_CRAN)/*.tar.gz $(SRC_DIST_CRAN)
	cp -rp $(DIST_CRAN)/checksums.txt $(SRC_DIST_CRAN)
	cp -rp $(DIST_RFORGE)/*.tar.gz $(SRC_DIST_RFORGE)
	cp -rp $(DIST_RFORGE)/checksums.txt $(SRC_DIST_RFORGE)

#
# cleaning
#
# Since building all the vendor dependencies from source is slow, we
# don't clean them with the `clean' target. We clean them with the
# `distclean' target.
#
clean-local: clean-local-logs
distclean-local: distclean-local-dist-dir distclean-local-lib-dir

.PHONY: dist-clean-local-dist-dir
distclean-local-dist-dir:
	-rm -rf $(DIST)
	-rm -f $(PKGS_CRAN) $(PKGS_RFORGE) $(PKGS_RFORGE_LATE)

.PHONY: distclean-local-lib.dir
distclean-local-lib-dir:
	-rm -rf $(BUILD_DEP_DIR)

.PHONY: clean-local-pkgs-dir
clean-local-pkgs-dir:
.PHONY: clean-local-logs
clean-local-logs:
	-rm -f @builddir@/*.log


#
# Checksums
#

.PHONY: generate-checksums
generate-checksums: | remove-checksums do-generate-checksums

.PHONY: remove-checksums
remove-checksums:
	@echo "WARNING: regenerating checksums from distribution files"
	-@rm -f $(DIST_CRAN)/checksums.txt
	-@rm -f $(DIST_RFORGE)/checksums.txt

do-generate-checksums: $(DIST_CRAN)/checksums.txt $(DIST_RFORGE)/checksums.txt

# Note that directories may be empty of tar files, in which case we
# want to succeed silently.
.PHONY: check-sums
check-sums: $(DIST_FILES) $(DIST_FILES_LATE)
	@echo "Checking distribution file checksums..."
	cd $(DIST_CRAN) && if ls *.tar.gz 1> /dev/null 2>&1; then sha256sum --quiet --ignore-missing -c checksums.txt; fi
	cd $(DIST_RFORGE) && if ls *.tar.gz 1> /dev/null 2>&1; then sha256sum --quiet --ignore-missing -c checksums.txt; fi

$(DIST_CRAN)/checksums.txt $(DIST_RFORGE)/checksums.txt:
	cd $(@D) && $(SHA256SUM) *.tar.gz > checksums.txt

#
# install
#
install-exec-local: vendor-install
uninstall-local: uninstall-local-pkgs

.PHONY: uninstall-local-pkgs
uninstall-local-pkgs:
	-rm -rf $(R_SITE_LIB)

#
# Directories
#
$(PKGS_DIR):
	$(MKDIR_P) $(PKGS_DIR)

$(BUILD_DEP_DIR):
	$(MKDIR_P) $(BUILD_DEP_DIR)

$(R_SITE_LIB):
	$(MKDIR_P) $(R_SITE_LIB)
