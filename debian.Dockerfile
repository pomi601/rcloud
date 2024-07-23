# syntax=docker/dockerfile:1.7-labs
# needed for COPY --exclude
# build with: docker buildx build -f debian.Dockerfile -t rcloud .

#
# base: this stage is a minimal debian installation with an rcloud user created
#
FROM debian as base

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install --no-install-recommends -y \
    curl \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Make rcloud user
RUN useradd -m rcloud

#
# build-dep: this stage includes all debian build dependencies
# required to build rcloud from source.
#
FROM base as build-dep

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install --no-install-recommends -y \
    automake \
    build-essential \
    git \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libssl-dev \
    pkg-config \
    r-base \
    wget \
    \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

#
# a development environment target
#
# Use like this:
#
# docker buildx build --target dev -f debian.Dockerfile --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t rcloud-dev .
# docker create --init --name rcloud-dev -v/home/me/src:/home/dev/src -p8080:8080 rcloud-dev
# docker start rcloud-dev # runs forever
# docker exec -it rcloud-dev bash
FROM build-dep as dev

ARG UID=1001
ARG GID=1001
ARG USER=dev

# Set locale: needed because rcloud won't run in C locale
RUN echo "en_NZ.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=en_NZ.UTF-8
ENV ROOT=/data/rcloud


# install runtime system dependencies for testing
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked   \
    apt-get update && apt-get install -y                    \
    procps                                                  \
    redis-server


RUN groupadd -g $GID $USER && useradd -m -u $UID -g $GID $USER
USER $USER
WORKDIR /home/$USER

# ENTRYPOINT ["/bin/bash", "-c"]
# CMD ["sleep infinity"]

#
# build: build vendored sources first, then our sources. At the end of
# the stage, everything will be installed in
# /usr/local/lib/rcloud/site-library
#
FROM build-dep as build
WORKDIR /data/rcloud
RUN chown -R rcloud:rcloud /data/rcloud

# Copy build instructions, checksum and install, then remove dist files.
# Copies existing tarfiles, if any, from build context.
# Documentation is part of the build.
COPY configure.ac .
COPY m4 m4
COPY Makefile.am .
COPY VERSION .
COPY vendor/Makefile.am vendor/
COPY vendor/dist/cran/checksums.txt vendor/dist/cran/checksums.txt
COPY vendor/dist/cran/*.tar.gz vendor/dist/cran/
COPY vendor/dist/rforge/checksums.txt vendor/dist/rforge/checksums.txt
COPY vendor/dist/rforge/*.tar.gz vendor/dist/rforge/

# set up autoconf and make a build directory, then fetch all our
# vendored dependencies, which are defined in vendor/Makefile.am.
# checksums are verified in the make all step.
RUN --mount=type=cache,target=/data/rcloud/build \
    autoreconf --install \
    && mkdir -p ./build \
    && cd build \
    && ../configure \
    && make vendor-fetch

# build and install rcloud sources and remaining ("late") vendored
# dependents.
WORKDIR /data/rcloud
COPY build-aux       build-aux
COPY conf            conf
COPY doc             doc
COPY htdocs          htdocs
COPY packages        packages
COPY rcloud.client   rcloud.client
COPY rcloud.packages rcloud.packages
COPY rcloud.support  rcloud.support
COPY scripts         scripts
COPY services        services
COPY vendor/dist/cran/checksums.txt   vendor/dist/cran/
COPY vendor/dist/rforge/checksums.txt vendor/dist/rforge/
COPY Gruntfile.js    .
COPY LICENSE         LICENSE
COPY NEWS.md         .
COPY README-CREDENTIALS.txt .
COPY README.md       .
COPY package-lock.json    .
COPY package.json    .
RUN --mount=type=cache,target=/data/rcloud/build \
    cd build && make && make late && make install

#
# build-js: this stage builds the rcloud JavaScript bundles and its dependencies.
#
FROM build-dep as build-js

# Make htdocs directory
WORKDIR /data/rcloud/htdocs
WORKDIR /data/rcloud
RUN chown -R rcloud:rcloud /data/rcloud

# Install MathJax
COPY scripts/fetch-mathjax.sh scripts/fetch-mathjax.sh

# tell the install script we're where it wants us to be
RUN mkdir rcloud.support \
    && touch rcloud.support/DESCRIPTION \
    && sh scripts/fetch-mathjax.sh \
    && rm -r rcloud.support

# Do JavaScript dependencies build

COPY --chown=rcloud:rcloud Gruntfile.js       .
COPY --chown=rcloud:rcloud package.json       .
COPY --chown=rcloud:rcloud package-lock.json  .

USER rcloud:rcloud
ENV PYTHON=python3
RUN npm ci

# Do JavaScript bundle

COPY --chown=rcloud:rcloud htdocs/css      htdocs/css
COPY --chown=rcloud:rcloud htdocs/js       htdocs/js
COPY --chown=rcloud:rcloud htdocs/lib      htdocs/lib
COPY --chown=rcloud:rcloud htdocs/sass     htdocs/sass
COPY --chown=rcloud:rcloud LICENSE         LICENSE
COPY --chown=rcloud:rcloud VERSION         VERSION

RUN node_modules/grunt-cli/bin/grunt

#
# runtime: this is the final stage which brings everything from the
# prior stages together. It also pulls in the remaining debian
# packages needed for runtime.
#
FROM base as runtime
USER root
WORKDIR /data/rcloud
RUN chown -f rcloud:rcloud /data/rcloud

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    git \
    redis-server \
    \
    jupyter \
    python3-ipython \
    python3-ipykernel \
    python3-nbconvert \
    python3-nbformat \
    python3-jupyter-client \
    python3-jupyter-core \
    \
    r-base \
    && rm -rf /var/lib/apt/lists/*

# Set locale: needed because rcloud won't run in C locale
RUN echo "en_NZ.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=en_NZ.UTF-8
ENV ROOT=/data/rcloud

# Copy site-library and rcloud library
COPY --from=build /usr/local/lib/R/site-library /usr/local/lib/R/site-library
COPY --from=build /usr/local/lib/rcloud/site-library /usr/local/lib/rcloud/site-library

# Copy source directories from context
COPY --chown=rcloud:rcloud scripts /data/rcloud/scripts
COPY --chown=rcloud:rcloud services /data/rcloud/services
COPY --chown=rcloud:rcloud htdocs /data/rcloud/htdocs

# Copy JavaScript artifacts from build-js
COPY --from=build-js --chown=rcloud:rcloud /data/rcloud/htdocs /data/rcloud/htdocs
COPY --from=build-js --chown=rcloud:rcloud /data/rcloud/node_modules /data/rcloud/node_modules

# Copy conf directory and version
COPY --chown=rcloud:rcloud conf /data/rcloud/conf
COPY --from=build-js --chown=rcloud:rcloud /data/rcloud/VERSION /data/rcloud/VERSION

# Make gists directory
RUN mkdir -p data/gists && chown -Rf rcloud:rcloud data

RUN cp conf/rcloud.conf.docker conf/rcloud.conf \
    && cp conf/rserve.conf.docker conf/rserve.conf

EXPOSE 8080
ENV R_LIBS_USER /usr/local/lib/rcloud/site-library

# -d: DEBUG
USER rcloud:rcloud
ENTRYPOINT ["/bin/bash", "-c", "redis-server & sh conf/start && sleep infinity"]
