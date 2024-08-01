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
	$(BUILD_DEP_DIR)/sys

$(PKGS_DIR)/FastRWeb.tar.gz: \
	$(BUILD_DEP_DIR)/base64enc \
	$(BUILD_DEP_DIR)/Cairo

$(PKGS_DIR)/openssl.tar.gz: \
	$(BUILD_DEP_DIR)/askpass

$(PKGS_DIR)/PKI.tar.gz: \
	$(BUILD_DEP_DIR)/base64enc

$(PKGS_DIR)/RcppTOML.tar.gz: \
	$(BUILD_DEP_DIR)/Rcpp

$(PKGS_DIR)/RCurl.tar.gz: \
	$(BUILD_DEP_DIR)/bitops

$(PKGS_DIR)/lifecycle.tar.gz: \
	$(BUILD_DEP_DIR)/cli \
	$(BUILD_DEP_DIR)/glue \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/here.tar.gz: \
	$(BUILD_DEP_DIR)/rprojroot

$(PKGS_DIR)/Rook.tar.gz: \
	$(BUILD_DEP_DIR)/brew

$(PKGS_DIR)/httr.tar.gz: \
	$(BUILD_DEP_DIR)/curl \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/mime \
	$(BUILD_DEP_DIR)/openssl \
	$(BUILD_DEP_DIR)/R6

$(PKGS_DIR)/cachem.tar.gz: \
	$(BUILD_DEP_DIR)/fastmap \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/memoise.tar.gz: \
	$(BUILD_DEP_DIR)/cachem \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/sendmailR.tar.gz: \
	$(BUILD_DEP_DIR)/base64enc

$(PKGS_DIR)/vctrs.tar.gz: \
	$(BUILD_DEP_DIR)/cli \
	$(BUILD_DEP_DIR)/glue \
	$(BUILD_DEP_DIR)/lifecycle \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/stringr.tar.gz: \
	$(BUILD_DEP_DIR)/cli \
	$(BUILD_DEP_DIR)/glue \
	$(BUILD_DEP_DIR)/lifecycle \
	$(BUILD_DEP_DIR)/magrittr \
	$(BUILD_DEP_DIR)/rlang \
	$(BUILD_DEP_DIR)/stringi \
	$(BUILD_DEP_DIR)/vctrs

$(PKGS_DIR)/reticulate.tar.gz: \
	$(BUILD_DEP_DIR)/here \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/png \
	$(BUILD_DEP_DIR)/rappdirs \
	$(BUILD_DEP_DIR)/Rcpp \
	$(BUILD_DEP_DIR)/RcppTOML \
	$(BUILD_DEP_DIR)/rlang \
	$(BUILD_DEP_DIR)/withr

$(PKGS_DIR)/markdown.tar.gz: \
	$(BUILD_DEP_DIR)/commonmark \
	$(BUILD_DEP_DIR)/xfun

$(PKGS_DIR)/tinytex.tar.gz: \
	$(BUILD_DEP_DIR)/xfun

$(PKGS_DIR)/highr.tar.gz: \
	$(BUILD_DEP_DIR)/xfun

$(PKGS_DIR)/knitr.tar.gz: \
	$(BUILD_DEP_DIR)/evaluate \
	$(BUILD_DEP_DIR)/highr \
	$(BUILD_DEP_DIR)/xfun \
	$(BUILD_DEP_DIR)/yaml

$(PKGS_DIR)/htmltools.tar.gz: \
	$(BUILD_DEP_DIR)/base64enc \
	$(BUILD_DEP_DIR)/digest \
	$(BUILD_DEP_DIR)/fastmap \
	$(BUILD_DEP_DIR)/knitr \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/sass.tar.gz: \
	$(BUILD_DEP_DIR)/fs \
	$(BUILD_DEP_DIR)/htmltools \
	$(BUILD_DEP_DIR)/R6 \
	$(BUILD_DEP_DIR)/rappdirs \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/fontawesome.tar.gz: \
	$(BUILD_DEP_DIR)/htmltools \
	$(BUILD_DEP_DIR)/rlang

$(PKGS_DIR)/jquerylib.tar.gz: \
	$(BUILD_DEP_DIR)/htmltools

$(PKGS_DIR)/bslib.tar.gz: \
	$(BUILD_DEP_DIR)/base64enc \
	$(BUILD_DEP_DIR)/cachem \
	$(BUILD_DEP_DIR)/fastmap \
	$(BUILD_DEP_DIR)/htmltools \
	$(BUILD_DEP_DIR)/jquerylib \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/lifecycle \
	$(BUILD_DEP_DIR)/memoise \
	$(BUILD_DEP_DIR)/mime \
	$(BUILD_DEP_DIR)/rlang \
	$(BUILD_DEP_DIR)/sass

$(PKGS_DIR)/rmarkdown.tar.gz: \
	$(BUILD_DEP_DIR)/bslib \
	$(BUILD_DEP_DIR)/evaluate \
	$(BUILD_DEP_DIR)/fontawesome \
	$(BUILD_DEP_DIR)/htmltools \
	$(BUILD_DEP_DIR)/jquerylib \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/knitr \
	$(BUILD_DEP_DIR)/tinytex \
	$(BUILD_DEP_DIR)/xfun \
	$(BUILD_DEP_DIR)/yaml

$(PKGS_DIR)/guitar.tar.gz: \
	$(BUILD_DEP_DIR)/Rcpp \
	$(BUILD_DEP_DIR)/BH \
	$(BUILD_DEP_DIR)/stringr

$(PKGS_DIR)/github.tar.gz: \
	$(BUILD_DEP_DIR)/httr \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/Rook \
	$(BUILD_DEP_DIR)/stringr

$(PKGS_DIR)/githubgist.tar.gz: \
	$(BUILD_DEP_DIR)/gist

$(PKGS_DIR)/rcloud.solr.tar.gz: \
	$(BUILD_DEP_DIR)/rjson \
	$(BUILD_DEP_DIR)/Rserve \
	$(BUILD_DEP_DIR)/httr \
	$(BUILD_DEP_DIR)/ulog \
	$(BUILD_DEP_DIR)/R6 \
	$(BUILD_DEP_DIR)/rcloud.support


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
	&& mv $${TARBALL} $(PKGS_DIR)/$${STEM}.tar.gz

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
