# RCloud

See [upstream's README](README-upstream.md).

# About this fork

This fork of [rcloud](https://github.com/att/rcloud) provides an
updated and reproducible build system targeted to Debian 12 Bookworm
with tools to make it easier to develop and test enhancements to
rcloud as well as to deploy it.

There are two main components to the build system: autotools and
docker. The use of docker is optional, but has many advantages.

The autotools system provides the traditional `configure && make &&
make install` experience for end users. Detailed instructions follow,
however, because rcloud has a few additional required steps due to its
many external dependencies.

# Quick start

If you're on a system that already has the necessary system
requirements, you can just configure, build and run a single-user
version of RCloud from this repository:

```sh
$ configure
$ make -j16
$ make run
```

Open a browser to https://127.0.0.1:8080/login.R and you should see
RCloud's main interface.

To stop the server:

```sh
$ make stop
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
build time system requirements, and fulfill them with Nix, Docker,
Podman or however you like.

## Using Docker

Using a docker "devcontainer" is the simplest approach to enure your
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
$ scripts/devcontainer.sh build -f debian.Dockerfile --target dev --tag rcloud-dev
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
$ scripts/devcontainer.sh run rcloud-dev
```

This will bind to your local filesystem and also bind a random port
number you can use for testing and drop you in a bash shell. See
`--help` for more information. From here you can use the build system
to build new versions of RCloud after editing the code.

```sh
$ scripts/devcontainer.sh --help
```

## Caching the downloaded R package dependencies

You will notice many `FETCH` lines when making the project the first
time, as the build system downloads its dependencies. To avoid doing
this repeatedly if you delete your `build` directory, run the
`vendor-copy` target:

```sh
$ make vendor-copy
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
$ make run
```

To stop the service, use the `make stop` target.

```sh
$ make stop
```

## Edit - compile - run

Subsequently, to rebuild only what is necessary and to run the
service:

```sh
$ make
$ make run
```

# Building and running a docker image

First ensure docker is properly installed and works:

```sh
$ docker run hello-world
```

Then use the utility makefile to build an image tagged `rcloud`:
```sh
$ make -f docker.Makefile build
```

After a few minutes, if the build is successful, you may:
```sh
$ make -f docker.Makefile run
```

# Using nix-shell

If you have Nix installed, a simple `nix-shell` will create the
necessary environment to build, with all system requirements
installed. This is detailed in the file [shell.nix](./shell.nix).
