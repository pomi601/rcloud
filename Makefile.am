## Process this file with automake to produce Makefile.in
SHELL = /bin/sh
SUBDIRS = vendor

include vendor/depend.mk

# Be quiet about entering and leaving directories
MAKEFLAGS = s

R_SITE_LIB       = $(DESTDIR)@libdir@/rcloud/site-library
R_INSTALL        = R CMD INSTALL --no-docs -l $(R_SITE_LIB)

# Build an R package from a directory of source files
R_BUILD          = R CMD build

# Build an R package from a tar.gz tarball of source files
R_BUILD_TGZ      = R CMD INSTALL --no-docs --build -l $(BUILD_DEP_DIR)

# Install an R package from a tar.gz tarball of source or binary files
R_BUILD_DEP      = R CMD INSTALL --no-docs -l $(BUILD_DEP_DIR)

RCLOUD_PKGS =			\
      gist			\
      gitgist			\
      githubgist		\
      rcloud.client		\
      rcloud.support		\
      rcloud.enviewer		\
      rcloud.jupyter		\
      rcloud.lux		\
      rcloud.notebook.info	\
      rcloud.python		\
      rcloud.r			\
      rcloud.rmarkdown		\
      rcloud.sh			\
      rcloud.viewer		\
      rcloud.web

BUILD_DEP_PKGS = $(addprefix $(BUILD_DEP_DIR)/,$(RCLOUD_PKGS))

RCLOUD_OUT =			\
  $(addprefix $(PKGS_DIR)/,	\
    $(addsuffix .tar.gz,	\
      $(RCLOUD_PKGS)		\
      ))

RCLOUD_INSTALLED = \
  $(addprefix $(R_SITE_LIB)/,$(RCLOUD_PKGS)) \
  $(addprefix $(R_SITE_LIB)/,rcloud.solr ulog)

GIST_DIR		= packages/gist
GITGIST_DIR		= packages/gitgist
GITHUBGIST_DIR		= packages/githubgist
RCLOUD_CLIENT_DIR	= rcloud.client
RCLOUD_SUPPORT_DIR	= rcloud.support
ENVIEWER_DIR		= rcloud.packages/rcloud.enviewer
JUPYTER_DIR		= rcloud.packages/rcloud.jupyter
LUX_DIR			= rcloud.packages/rcloud.lux
NOTEBOOK_DIR		= rcloud.packages/rcloud.notebook.info
PYTHON_DIR		= rcloud.packages/rcloud.python
RCLOUD_R_DIR		= rcloud.packages/rcloud.r
RMARKDOWN_DIR		= rcloud.packages/rcloud.rmarkdown
RCLOUD_SH_DIR		= rcloud.packages/rcloud.sh
VIEWER_DIR		= rcloud.packages/rcloud.viewer
WEB_DIR			= rcloud.packages/rcloud.web
PACKAGE_META		= DESCRIPTION NAMESPACE

gist_sources =								\
  $(addprefix $(GIST_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(GIST_DIR)/R/*.R)
gist_deps = $(gist_sources)

gitgist_sources =							\
  $(addprefix $(GITGIST_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(GITGIST_DIR)/R/*.R)
gitgist_deps = $(gitgist_sources)

githubgist_sources =							\
  $(addprefix $(GITHUBGIST_DIR)/,$(PACKAGE_META))			\
  $(wildcard $(srcdir)/$(GITHUBGIST_DIR)/R/*.R)
githubgist_deps = $(githubgist_sources)

rcloud_client_sources =							\
  $(addprefix $(RCLOUD_CLIENT_DIR)/,$(PACKAGE_META))			\
  $(wildcard $(srcdir)/$(RCLOUD_CLIENT_DIR)/R/*.R)
rcloud_client_deps = $(rcloud_client_sources)

rcloud_support_sources =						\
  $(addprefix $(RCLOUD_SUPPORT_DIR)/,$(PACKAGE_META))			\
  $(wildcard $(srcdir)/$(RCLOUD_SUPPORT_DIR)/R/*.R)			\
  $(wildcard $(srcdir)/$(RCLOUD_SUPPORT_DIR)/src/*.c)			\
  $(wildcard $(srcdir)/$(RCLOUD_SUPPORT_DIR)/inst/javascript/*.js)	\
  $(wildcard $(srcdir)/$(RCLOUD_SUPPORT_DIR)/man/*.Rd)
rcloud_support_deps = $(rcloud_support_sources)				\
  $(BUILD_DEP_DIR)/gist

rcloud_enviewer_sources =						\
  $(addprefix $(ENVIEWER_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(ENVIEWER_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(ENVIEWER_DIR)/inst/javascript/*.js)
rcloud_enviewer_deps = $(rcloud_enviewer_sources)			\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_jupyter_sources =						\
  $(addprefix $(JUPYTER_DIR)/,$(PACKAGE_META) README.md)		\
  $(wildcard $(srcdir)/$(JUPYTER_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(JUPYTER_DIR)/inst/jupyter/*.py)		\
  $(wildcard $(srcdir)/$(JUPYTER_DIR)/inst/jupyter/*.json)
rcloud_jupyter_deps = $(rcloud_jupyter_sources)				\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_lux_sources =							\
  $(addprefix $(LUX_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(LUX_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(LUX_DIR)/inst/javascript/*.js)
rcloud_lux_deps = $(rcloud_lux_sources)					\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_notebook_sources =						\
  $(addprefix $(NOTEBOOK_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(NOTEBOOK_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(NOTEBOOK_DIR)/inst/javascript/*.js)
rcloud_notebook_deps = $(rcloud_notebook_sources)			\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_python_sources =							\
  $(addprefix $(PYTHON_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(PYTHON_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(PYTHON_DIR)/inst/python/*.py)
rcloud_python_deps = $(rcloud_python_sources)				\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_r_sources =							\
  $(addprefix $(RCLOUD_R_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(RCLOUD_R_DIR)/R/*.R)
rcloud_r_deps = $(rcloud_r_sources)					\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_rmarkdown_sources =						\
  $(addprefix $(RMARKDOWN_DIR)/,$(PACKAGE_META))			\
  $(wildcard $(srcdir)/$(RMARKDOWN_DIR)/R/*.R)
rcloud_rmarkdown_deps = $(rcloud_rmarkdown)				\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_sh_sources =							\
  $(addprefix $(RCLOUD_SH_DIR)/,$(PACKAGE_META))			\
  $(wildcard $(srcdir)/$(RCLOUD_SH_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(RCLOUD_SH_DIR)/src/*.c)
rcloud_sh_deps = $(rcloud_sh_sources)					\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_viewer_sources =							\
  $(addprefix $(VIEWER_DIR)/,$(PACKAGE_META))				\
  $(wildcard $(srcdir)/$(VIEWER_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(VIEWER_DIR)/inst/javascript/*.js)
rcloud_viewer_deps = $(rcloud_viewer_sources)				\
  $(BUILD_DEP_DIR)/rcloud.support

rcloud_web_sources =							\
  $(addprefix $(WEB_DIR)/,$(PACKAGE_META) NEWS)				\
  $(wildcard $(srcdir)/$(WEB_DIR)/R/*.R)				\
  $(wildcard $(srcdir)/$(WEB_DIR)/inst/javascript/*.js)			\
  $(wildcard $(srcdir)/$(WEB_DIR)/man/*.Rd)
rcloud_web_deps = $(rcloud_web_sources)					\
  $(BUILD_DEP_DIR)/rcloud.support

htdocs_sources =										\
  $(srcdir)/package.json									\
  $(srcdir)/package-lock.json									\
  $(srcdir)/Gruntfile.js									\
  $(wildcard $(srcdir)/htdocs/*.js)								\
  $(wildcard $(srcdir)/htdocs/*.png)								\
  $(wildcard $(srcdir)/htdocs/*.html)								\
  $(wildcard $(srcdir)/htdocs/*.txt)								\
  $(wildcard $(srcdir)/htdocs/*.R)								\
  $(wildcard $(srcdir)/htdocs/css/*.png)							\
  $(wildcard $(srcdir)/htdocs/css/images/*.png)							\
  $(wildcard $(srcdir)/htdocs/font/*.otf)							\
  $(wildcard $(srcdir)/htdocs/font/*.eot)							\
  $(wildcard $(srcdir)/htdocs/font/*.svg)							\
  $(wildcard $(srcdir)/htdocs/font/*.svgz)							\
  $(wildcard $(srcdir)/htdocs/font/*.ttf)							\
  $(wildcard $(srcdir)/htdocs/font/*.woff)							\
  $(wildcard $(srcdir)/htdocs/img/*.gif)							\
  $(wildcard $(srcdir)/htdocs/img/*.jpg)							\
  $(wildcard $(srcdir)/htdocs/img/*.png)							\
  $(wildcard $(srcdir)/htdocs/js/*.js)								\
  $(wildcard $(srcdir)/htdocs/js/notebook/*.js)							\
  $(wildcard $(srcdir)/htdocs/js/tree/*.js)							\
  $(wildcard $(srcdir)/htdocs/js/ui/*.js)							\
  $(wildcard $(srcdir)/htdocs/lib/js/*.js)							\
  $(wildcard $(srcdir)/htdocs/lib/js/ace/*.js)							\
  $(wildcard $(srcdir)/htdocs/lib/js/ace/*.md)							\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/*.js)						\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/base/worker/*.js)				\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/basic-languages/src/*.js)			\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/editor/*.css)					\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/editor/*.js)					\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/editor/contrib/suggest/browser/media/*.svg)	\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/editor/standalone/browser/quickOpen/*.svg)	\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/language/css/*.js)				\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/language/html/*.js)				\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/language/json/*.js)				\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/language/typescript/lib/*.js)			\
  $(wildcard $(srcdir)/htdocs/lib/js/monaco/vs/language/typescript/src/*.js)			\
  $(wildcard $(srcdir)/htdocs/sass/*.scss)							\
  $(wildcard $(srcdir)/htdocs/sass/components/*.scss)						\
  $(wildcard $(srcdir)/htdocs/sass/utils/*.scss)						\
  $(wildcard $(srcdir)/htdocs/sass/vendor/*.scss)

conf_sources =				\
  $(wildcard $(srcdir)/conf/*)		\
  $(wildcard $(srcdir)/conf/solr/*)	\
  $(wildcard $(srcdir)/conf/*)		\
  $(wildcard $(srcdir)/conf/solr/lang/*)

nobase_dist_pkgdata_DATA =						\
  $(gist_sources)							\
  $(gitgist_sources)							\
  $(githubgist_sources)							\
  $(rcloud_client_sources)						\
  $(rcloud_support_sources)						\
  $(rcloud_enviewer_sources)						\
  $(rcloud_jupyter_sources)						\
  $(rcloud_lux_sources)							\
  $(rcloud_notebook_sources)						\
  $(rcloud_python_sources)						\
  $(rcloud_r_sources)							\
  $(rcloud_rmarkdown_sources)						\
  $(rcloud_sh_sources)							\
  $(rcloud_viewer_sources)						\
  $(rcloud_web_sources)							\
  $(htdocs_sources)							\
  $(conf_sources)							\
  scripts/bootstrapR.sh							\
  scripts/build.sh							\
  scripts/build_package.sh						\
  scripts/conf-keys.sh							\
  scripts/convert_ipynb_to_rcloud_notebook.py				\
  scripts/fetch-mathjax.sh						\
  scripts/fresh_start.sh						\
  scripts/migrate-ghe2gists.pl						\
  scripts/migrate2ff.sh							\
  scripts/migrate2redis.sh						\
  scripts/rebuildjs.sh							\
  scripts/selconf							\
  scripts/shutdown.sh							\
  scripts/travis-tool.sh						\
  scripts/upgradeRCS1_0.R						\
  services/README.md							\
  services/rcloud-proxy							\
  services/rcloud-qap							\
  services/rcloud-script						\
  services/rcloud-script-start						\
  services/rcloud-sks							\
  services/rcloud-solr							\
  services/rcloud-start							\
  services/ubuntu/init.d/rcloud-proxy					\
  services/ubuntu/init.d/rcloud-qap					\
  services/ubuntu/init.d/rcloud-script					\
  services/ubuntu/init.d/rcloud-sks					\
  services/ubuntu/init.d/rcloud-solr					\
  services/ubuntu/init.d/rcloud-ulogd					\
  vendor/dist/cran/checksums.txt					\
  vendor/dist/rforge/checksums.txt					\
  LICENSE								\
  NEWS.md								\
  README-CREDENTIALS.txt						\
  README.md								\
  VERSION


$(BUILD_DEP_DIR)/%: $(PKGS_DIR)/%.tar.gz
	$(AM_V_GEN) $(R_BUILD_DEP) $< > /dev/null 2>&1

# Build a tarball. Copies source directory to a temp directory first,
# so that build artifacts aren't left in our source tree.
$(PKGS_DIR)/%.tar.gz:
	$(AM_V_GEN) STEM=$(basename $(basename $(@F)))		\
	&& rtemp=$$(mktemp -d)					\
	&& cp -R $</* $$rtemp/					\
	&& chmod -R +w $$rtemp					\
	&& $(R_BUILD) $$rtemp > $(OUT_DIR)/$(@F).log 2>&1	\
	&& if [ -e $${STEM}_*.tgz ]; then TARBALL=$${STEM}_*.tgz; else TARBALL=$${STEM}_*.tar.gz; fi \
	&& rm $(OUT_DIR)/$(@F).log				\
	&& mv $${TARBALL} $(PKGS_DIR)/$${STEM}.tar.gz		\
	&& rm -r $$rtemp					\
	|| (cat $(OUT_DIR)/$(@F).log && false)

# NOTE: ensure path is the first dependency
$(PKGS_DIR)/gist.tar.gz:             $(GIST_DIR)           $(gist_deps)
$(PKGS_DIR)/gitgist.tar.gz:          $(GITGIST_DIR)        $(gitgist_deps)
$(PKGS_DIR)/githubgist.tar.gz:       $(GITHUBGIST_DIR)     $(githubgist_deps)
$(PKGS_DIR)/rcloud.client.tar.gz:    $(RCLOUD_CLIENT_DIR)  $(rcloud_client_deps)
$(PKGS_DIR)/rcloud.support.tar.gz:   $(RCLOUD_SUPPORT_DIR) $(rcloud_support_deps)
$(PKGS_DIR)/rcloud.enviewer.tar.gz:  $(ENVIEWER_DIR)       $(rcloud_enviewer_deps)
$(PKGS_DIR)/rcloud.jupyter.tar.gz:   $(JUPYTER_DIR)        $(rcloud_jupter_deps)
$(PKGS_DIR)/rcloud.lux.tar.gz:       $(LUX_DIR)            $(rcloud_lux_deps)
$(PKGS_DIR)/rcloud.notebook.info.tar.gz: $(NOTEBOOK_DIR)   $(rcloud_notebook_deps)
$(PKGS_DIR)/rcloud.python.tar.gz:    $(PYTHON_DIR)         $(rcloud_python_deps)
$(PKGS_DIR)/rcloud.r.tar.gz:         $(RCLOUD_R_DIR)       $(rcloud_r_deps)
$(PKGS_DIR)/rcloud.rmarkdown.tar.gz: $(RMARKDOWN_DIR)      $(rcloud_rmarkdown_deps)
$(PKGS_DIR)/rcloud.sh.tar.gz:        $(RCLOUD_SH_DIR)      $(rcloud_sh_deps)
$(PKGS_DIR)/rcloud.viewer.tar.gz:    $(VIEWER_DIR)         $(rcloud_viewer_deps)
$(PKGS_DIR)/rcloud.web.tar.gz:       $(WEB_DIR)            $(rcloud_web_deps)


$(PKGS_DIR)/gitgist.tar.gz: \
	$(BUILD_DEP_DIR)/guitar \
	$(BUILD_DEP_DIR)/PKI

$(PKGS_DIR)/githubgist.tar.gz: \
	$(BUILD_DEP_DIR)/gist \
	$(BUILD_DEP_DIR)/github \
	$(BUILD_DEP_DIR)/httr

$(PKGS_DIR)/rcloud.client.tar.gz: \
	$(BUILD_DEP_DIR)/RSclient \
	$(BUILD_DEP_DIR)/FastRWeb

$(PKGS_DIR)/rcloud.support.tar.gz: \
	$(BUILD_DEP_DIR)/Cairo \
	$(BUILD_DEP_DIR)/FastRWeb \
	$(BUILD_DEP_DIR)/httr \
	$(BUILD_DEP_DIR)/jsonlite \
	$(BUILD_DEP_DIR)/knitr \
	$(BUILD_DEP_DIR)/markdown \
	$(BUILD_DEP_DIR)/mime \
	$(BUILD_DEP_DIR)/PKI \
	$(BUILD_DEP_DIR)/png \
	$(BUILD_DEP_DIR)/RCurl \
	$(BUILD_DEP_DIR)/Rserve \
	$(BUILD_DEP_DIR)/rediscc \
	$(BUILD_DEP_DIR)/rjson \
	$(BUILD_DEP_DIR)/sendmailR \
	$(BUILD_DEP_DIR)/unixtools \
	$(BUILD_DEP_DIR)/uuid \
	$(BUILD_DEP_DIR)/RSclient \
	$(BUILD_DEP_DIR)/rcloud.client \
	$(BUILD_DEP_DIR)/gist \
	$(BUILD_DEP_DIR)/gitgist

#
# Unfortunate duplication of rule from vendor/Makefile.am, because
# these two packages are fetched remotely, but cannot be built before
# rcloud.support. So we no longer attempt to build them using a `late`
# target in vendor/Makefile.am, because that caused failures in
# parallel builds.
#
$(PKGS_DIR)/rcloud.solr.tar.gz: \
	$(BUILD_DEP_DIR)/rjson \
	$(BUILD_DEP_DIR)/Rserve \
	$(BUILD_DEP_DIR)/httr \
	$(BUILD_DEP_DIR)/ulog \
	$(BUILD_DEP_DIR)/R6 \
	$(BUILD_DEP_DIR)/rcloud.support
# start rule
	$(AM_V_GEN) STEM=$(basename $(basename $(@F))) \
	&& SOURCEDIST=$${STEM}_*.tar.gz \
	&& if [ -e $(DIST_CRAN)/$${SOURCEDIST} ]; then \
	  $(R_BUILD_TGZ) $(DIST_CRAN)/$${SOURCEDIST} > $(@F).log 2>&1; \
	elif [ -e $(DIST_RFORGE)/$${SOURCEDIST} ]; then \
	  $(R_BUILD_TGZ) $(DIST_RFORGE)/$${SOURCEDIST} > $(@F).log 2>&1; \
	else \
	  echo "ERROR: can't find $${SOURCEDIST} anywhere..."; \
	  exit 1; \
	fi \
	&& if [ -e $${STEM}_*.tgz ]; then TARBALL=$${STEM}_*.tgz; else TARBALL=$${STEM}_*.tar.gz; fi \
	&& mv $${TARBALL} $(PKGS_DIR)/$${STEM}.tar.gz

$(PKGS_DIR)/ulog.tar.gz:
	$(AM_V_GEN) STEM=$(basename $(basename $(@F))) \
	&& SOURCEDIST=$${STEM}_*.tar.gz \
	&& if [ -e $(DIST_CRAN)/$${SOURCEDIST} ]; then \
	  $(R_BUILD_TGZ) $(DIST_CRAN)/$${SOURCEDIST} > $(@F).log 2>&1; \
	elif [ -e $(DIST_RFORGE)/$${SOURCEDIST} ]; then \
	  $(R_BUILD_TGZ) $(DIST_RFORGE)/$${SOURCEDIST} > $(@F).log 2>&1; \
	else \
	  echo "ERROR: can't find $${SOURCEDIST} anywhere..."; \
	  exit 1; \
	fi \
	&& if [ -e $${STEM}_*.tgz ]; then TARBALL=$${STEM}_*.tgz; else TARBALL=$${STEM}_*.tar.gz; fi \
	&& mv $${TARBALL} $(PKGS_DIR)/$${STEM}.tar.gz



# Make all targets. First builds rcloud packages, then builds the
# `late` target, which are vendored dependencies which also depend on
# rcloud packages.
all-local: js | $(RCLOUD_OUT) $(BUILD_DEP_PKGS) $(BUILD_DEP_RFORGE_LATE)


#
# cleaning
#
clean-local: clean-local-pkgs clean-local-logs clean-out-dir

.PHONY: clean-local-pkgs
clean-local-pkgs:
	-rm -f $(RCLOUD_OUT)

.PHONY: clean-local-logs
clean-local-logs:
	-rm -f $(builddir)/*.log

.PHONY: clean-out-dir
clean-out-dir:
	@echo "Removing directory $(OUT_DIR)"
	-rm -rf $(OUT_DIR)

#
# install
#
install-exec-local: $(RCLOUD_INSTALLED) | $(R_SITE_LIB)

$(R_SITE_LIB)/%: $(PKGS_DIR)/%.tar.gz
	$(AM_V_GEN) $(R_INSTALL) $< > /dev/null 2>&1

#
# Directories
#
$(OUT_DIR):
	$(MKDIR_P) $(OUT_DIR)

#(BUILD_DEP_DIR):
	$(MKDIR_P) $(BUILD_DEP_DIR)

#
# what to distribute in source package
#
dist_doc_DATA =			\
  doc/CONFIGURATION.md		\
  doc/INSTALL.md		\
  doc/RCloud-architecture.pdf	\
  doc/README.md

#
# javascript build
#
$(OUT_DIR)/htdocs/js/rcloud_bundle.min.js.gz: $(htdocs_sources)
	@echo "Building JavaScript in a temp directory..."	\
	&& jstemp=$$(mktemp -d)					\
	&& cp -R $(srcdir)/htdocs $$jstemp/			\
	&& cp $(srcdir)/package.json $$jstemp/			\
	&& cp $(srcdir)/package-lock.json $$jstemp/		\
	&& cp $(srcdir)/Gruntfile.js $$jstemp/			\
	&& cp $(srcdir)/VERSION $$jstemp/			\
	&& cd $$jstemp						\
	&& chmod -R +w .                                        \
	&& npm ci						\
	&& node_modules/grunt-cli/bin/grunt			\
	&& echo "Copying generated files to $(OUT_DIR)/htdocs/"	\
	&& cp -R htdocs/ $(OUT_DIR)/				\
	&& rm -r $$jstemp

js: $(OUT_DIR)/htdocs/js/rcloud_bundle.min.js.gz

#
# Some usefule targets for development use
#
.PHONY: devcontainer-build devcontainer-run devcontainer-root run

devcontainer-build:
	$(srcdir)/scripts/devcontainer.sh build -t rcloud-dev --target dev --file $(srcdir)/debian.Dockerfile

devcontainer-run:
	$(srcdir)/scripts/devcontainer.sh run -t rcloud-dev -p 8080 -b ..

devcontainer-root:
	$(srcdir)/scripts/devcontainer.sh run -t rcloud-dev --root -b ..

run:
	if [ ! -d "$(OUT_DIR)/run" ]; then $(MKDIR_P) "$(OUT_DIR)/run"; fi
	echo "Copying $(srcdir)/conf to $(OUT_DIR)/"							\
	&& cp -R "$(srcdir)/conf" "$(OUT_DIR)"
	if [ ! -f $(OUT_DIR)/conf/rcloud.conf ]; then							\
	echo "WARNING: conf/rcloud.conf not found, using rcloud.conf.docker";				\
	cp "$(srcdir)/conf/rcloud.conf.docker" "$(OUT_DIR)/conf/rcloud.conf";				\
	fi
	echo "Copying $(srcdir)/VERSION to $(OUT_DIR)/"							\
	&& cp "$(srcdir)/VERSION" "$(OUT_DIR)/"
	if ! redis-cli ping; then  redis-server & fi
	ROOT=$(realpath $(OUT_DIR)) R_LIBS=$(realpath ./out/lib) R_LIBS_USER=$(realpath ./out/lib)	\
	R --slave --no-restore --vanilla								\
	--file="$(realpath $(srcdir))/conf/run_rcloud.R"						\
	--args "$(realpath $(srcdir))/conf/rserve.conf.docker"

# This is a bit extreme but I can't see a pid file anywhere for redis-server.
# Killing Rserve via the pid file doesn't always work.
stop:
	kill $(shell cat "$(OUT_DIR)/run/rserve.pid")
	killall Rserve
	killall redis-server
