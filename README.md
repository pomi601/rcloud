# RCloud

See [upstream's README](README-upstream.md).

# About this fork

This fork of [rcloud](https://github.com/att/rcloud) provides an
updated and reproducible build system targeted to Debian 12 Bookworm
with tools to make it easier to develop and test enhancements to
rcloud as well as to deploy it.

# Quick start - Zig build

First, [install Zig version 0.14.0 or later](#install-zig) and all
system requirements needed to build.

Alternatively, if you have the Nix package manager installed:

```sh
nix develop
```

Then:

```sh
zig build
```

The build will complete in about 3 minutes. Then:

```sh
cd zig-out
conf/start2

# to stop the servers:
conf/stop
```

## Install Zig

The build system requires Zig version 0.14.0 or later. You can
download it from [Ziglang](https://ziglang.org/) or use the provided
download script which is used to build our Docker container.
The script must be run from the project root directory, because the
download script expects a zig/ subdirectory to already exist from
your current working directory:

```sh
zig/download.sh 0.14.0
```

This will download and extract the latest 0.14.0 pre-release build and
install it in the zig/ directory. You can add that directory to your
path, or simply run the zig executable by specifying its full path.
Zig will find its library based on the executable's location, not your
path.

# Quick start - Docker build

The same configuration can be built and run with Docker, which uses a
Debian base image. The file [docker.Makefile](./docker.Makefile)
includes targets and can be used as reference for the appropriate
docker commands. For example:

Build the image:

```sh
make -f docker.Makefile build
```

Run the image:

```sh
make -f docker.Makefile run
```

Other targets in the Makefile demonstrate other common Docker scenarios.

# Maintainer concerns

## Preparing an offline build

1. Complete a `zig build` as usual. This step will add an `assets`
   directory to `zig-out`.
1. Run `zig build dist-fat -Dassets=zig-out/assets`. This will
   generate a tarball `rcloud-full-{version}.tar.gz` in `zig-out`.
1. Transfer the file to another machine and extract it there.
1. Run `zig build -Dassets=zig-out/assets` to build without a network.

Note that you will need Zig (as well as all system requirements) on
the offline machine since you are still building from source. Simply
packing the zig/ directory and unpacking it on the other machine is
sufficient to have a working Zig installation.

## Preparing a source distribution

```sh
zig build dist
```

This will create `zig-out/rcloud-{version}.tar.gz`.

## Updating R dependencies

The build system automatically discovers new R package dependencies by
recursively walking the top-level package directories and examining
the DESCRIPTION files. It then queries the configured package
repositories for the latest versions available which satisfy any
version constraints expressed in the package definitions.

```sh
zig build update
```

will perform this process and rewrite `build-aux/config.json`. If any
package has been updated or added, its hash will initially be set to
the empty string. The first time `zig build` is run, a warning will be
echoed to the console to indicate that the hash is being updated.

----

# Older content

The following content has not been recently reviewed for accuracy.

# Quick start - Makefile

If you're on a system that already has the necessary system
requirements, you can just configure, build and run a single-user
version of RCloud from this repository:

```sh
configure
make -j16
make run
```

Open a browser to https://127.0.0.1:8080/login.R and you should see
RCloud's main interface.

To stop the server:

```sh
make stop
```

Build files are placed in an `out/` subdirectory. This directory is
removed by `make clean`. You may wish to configure and build from a
`build` subdirectory to prevent intermediate files and log files from
being generated in your source tree, but this is not required.

Note that the initial build will fetch several third-party
dependencies from package repositories, so Internet access is
required. We plan to package a "fat" source distribution that includes
all dependencies (subject to license restrictions), which can be built
without network access.

# Vendored dependencies

In order to provide a reproducible build, we explicitly version every
one of rcloud's external dependencies. For the JavaScript
dependencies, these are in the traditional `package-lock.json` file.

For R package dependencies, since there were no version requirements
in the upstream at the time of this fork, we took the latest versions
available. Rather than include the source code of external
dependencies in this repository, we include logic to retrieve them
from package libraries and compare their checksums to what we expect.

In order to build rcloud, these tarballs will be fetched by `make`
prior to building the first time.


# System requirements

Refer to [shell.nix](shell.nix) or
[debian.Dockerfile](debian.Dockerfile) for hints about runtime and
build time system requirements, and fulfil them with Nix, Docker,
Podman or however you like.

## Using Docker

Using a docker "devcontainer" is the simplest approach to ensure your
system has all the necessary requirements and provides a consistent
and reproducible development environment. There is a
[devcontainer.sh](scripts/devcontainer.sh) script to make this easy.

A devcontainer binds to your local filesystem, but uses its own system
tools. There is a one-time build process that may take several
minutes, to initially create the docker image. Subsequently, you "run"
the devcontainer in order to get a bash shell with your local
development directory mounted, so you can build the software.

Initially, build the devcontainer:

```sh
scripts/devcontainer.sh build -f debian.Dockerfile --target dev --tag rcloud-dev
```

This uses the [debian.Dockerfile](debian.Dockerfile) to build the
`dev` target (one of the multi-stage builds in the Dockerfile) and
tags it `rcloud-dev`.

The Dockerfile includes stages to fully obtain all third-party
dependencies, checksum them, and build all the RCloud software for a
single-user deployment. So we want to specify the `dev` stage to skip
all of that.

Next, run the devcontainer:

```sh
scripts/devcontainer.sh run rcloud-dev
```

This will bind to your local filesystem and also bind a random port
number you can use for testing and drop you in a bash shell. See
`--help` for more information. From here you can use the build system
to build new versions of RCloud after editing the code.

```sh
scripts/devcontainer.sh --help
```

## Caching the downloaded R package dependencies

You will notice many `FETCH` lines when making the project the first
time, as the build system downloads its dependencies. To avoid doing
this repeatedly if you delete your `build` directory, run the
`vendor-copy` target:

```sh
make vendor-copy
```

This will copy the downloaded tarballs into your source directory, at
`vendor/dist`.

## Configure rcloud and rserve

Ensure the files `conf/rcloud.conf` and `conf/rserve.conf` are
correct. Reference `rcloud.conf.docker` and `rserve.conf.docker` for a
working example that is used by the docker image.

## Running

Use the `make run` target defined in [Makefile.am](./Makefile.am).
This will start a redis server and start the Rserve process to host
rcloud.

```sh
make run
```

To stop the service, use the `make stop` target.

```sh
make stop
```

## Edit - compile - run

Subsequently, to rebuild only what is necessary and to run the
service:

```sh
make
make run
```

# Building and running a docker image

First ensure docker is properly installed and works:

```sh
docker run hello-world
```

Then use the utility makefile to build an image tagged `rcloud`:
```sh
make -f docker.Makefile build
```

After a few minutes, if the build is successful, you may:
```sh
make -f docker.Makefile run
```

# Using nix-shell

If you have Nix installed, a simple `nix-shell` will create the
necessary environment to build, with all system requirements
installed. This is detailed in the file [shell.nix](./shell.nix).

<!--  LocalWords:  RCloud md rcloud Zig zig Ziglang dist Dassets gz
<!--  LocalWords:  aux RCloud's Vendored rcloud's json debian Podman
<!--  LocalWords:  Dockerfile devcontainer rserve conf redis
 -->
 -->
 -->
