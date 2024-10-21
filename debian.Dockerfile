# build with: docker buildx build -f debian.Dockerfile -t rcloud .

ARG BUILD_JOBS=8

#
# base: this stage is a minimal debian installation with an rcloud user created
#
FROM debian as base

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked      \
    --mount=type=cache,target=/var/lib/apt,sharing=locked        \
    apt-get update && apt-get install --no-install-recommends -y \
    curl                                                         \
    git                                                          \
    locales                                                      \
    wget                                                         \
    && rm -rf /var/lib/apt/lists/*

# Make rcloud user
RUN useradd -m rcloud

#
# build-dep: this stage includes all debian system requirements
# required to build rcloud and its dependencies from source.
#
FROM base as build-dep

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked      \
    --mount=type=cache,target=/var/lib/apt,sharing=locked        \
    apt-get update && apt-get install --no-install-recommends -y \
    automake                                                     \
    build-essential                                              \
    libcairo2-dev                                                \
    libcurl4-openssl-dev                                         \
    libicu-dev                                                   \
    libssl-dev                                                   \
    pkg-config                                                   \
    r-base                                                       \
                                                                 \
    nodejs                                                       \
    npm                                                          \
    && rm -rf /var/lib/apt/lists/*

#
# build-dep-java: this stage includes build dependencies for java, for
# use with session key server
#
FROM base as build-dep-java

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked      \
    --mount=type=cache,target=/var/lib/apt,sharing=locked        \
    apt-get update && apt-get install --no-install-recommends -y \
    build-essential                                              \
    default-jdk                                                  \
    && rm -rf /var/lib/apt/lists/*

FROM build-dep-java as dev-sks
WORKDIR /data
RUN git clone --depth 1 https://github.com/s-u/SessionKeyServer.git && cd SessionKeyServer && make -j${BUILD_JOBS}

FROM dev-sks as runtime-sks
WORKDIR /data/SessionKeyServer
ENTRYPOINT ["/bin/bash", "-c", "sh run"]

#
# a development environment target
#
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


# add group, exiting successfully if it already exists
RUN groupadd -f -g $GID $USER && useradd -m -u $UID -g $GID $USER
USER $USER
WORKDIR /home/$USER

#
# build: builds all dependencies and RCloud sources
#
FROM build-dep as build
WORKDIR /data/rcloud
RUN chown -R rcloud:rcloud /data/rcloud

#
# Download a version of Zig 0.14.0
#
# NOTE: this is not reproducible, as the official ziglang.org site
# does not maintain older pre-release (master) builds. The download.sh
# script will download the latest master for version 0.14.0 available.
# When 0.14.0 is released (est. Jan 2025), this build will be
# reproducible.
#
COPY zig/download.sh zig/download.sh
RUN zig/download.sh 0.14.0

# Add zig executable to path
ENV PATH=/data/rcloud/zig:$PATH

# Copy sources to build context
COPY build.zig .
COPY build.zig.zon .
COPY VERSION .
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
COPY Gruntfile.js    .
COPY LICENSE         .
COPY package-lock.json    .
COPY package.json    .

# build
RUN zig build --summary new

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

# Copy build artifacts (zig-out)
COPY --from=build --chown=rcloud:rcloud /data/rcloud/zig-out /data/rcloud/zig-out

# Set RCloud root directory
ENV ROOT=/data/rcloud/zig-out

#
# runtime-simple: the single-user local RCloud installation
#
FROM runtime AS runtime-simple
WORKDIR /data/rcloud/zig-out

# Make gists directory
RUN mkdir -p data/gists && chown -Rf rcloud:rcloud data

## note that currently the start script will choose rserve conf based
## on results of a grep of the rcloud.conf file.
RUN cp conf/rcloud.conf.docker conf/rcloud.conf

EXPOSE 8080
ENV R_LIBS      /data/rcloud/zig-out/lib
ENV R_LIBS_USER /data/rcloud/zig-out/lib

# -d: DEBUG
USER rcloud:rcloud
ENTRYPOINT ["/bin/bash", "-c", "redis-server & sh conf/start && sleep infinity"]
