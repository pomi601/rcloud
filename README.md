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

# Building locally

Assuming you have just cloned the repository, do the following:

```sh
$ autoreconf --install
$ mkdir build && cd build
$ ../configure  # --help for options, --prefix etc
$ make
$ (sudo) make install
```

## Parallel build

Currently the build system is not robust to parallel builds, but it
will significantly speed up your first build of all the external
dependencies from source if you're willing to repeatedly invoke `make`
until it succeeds without doing any work. In other words:

```sh
$ make -j8
... some error
$ make -j8
... another error
$ make -j8
... no error, let's run it!
$ make run
```

Yes this is a bit silly in 2024 but here we are.

## Caching the downloaded R package dependencies

You will notice many `WGET` lines when making the project the first
time, as the build system downloads its dependencies. To avoid doing
this repeatedly if you delete your `build` directory, run the
`vendor-copy` target:

```sh
$ make vendor-copy
```

This will copy the downloaded tarballs into your source directory, at
`vendor/dist`.

## JavaScript

Currently, the JavaScript portions of this project are not built by
`make`, so you will have to build them manually:

```sh
# From the root of the repo, install all javascript dependencies
$ npm ci

# Build the javascript runtime files
$ node_modules/grunt-cli/bin/grunt
```

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

## Not working?

Please refer to the [debian.Dockerfile](./debian.Dockerfile) for
system requirements and build instructions that may not be correctly
documented in this README.

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

# Using a devcontainer

In order to keep your local development environment clean, you may
wish to use a devcontainer to build and run (for testing purposes)
rcloud:

First, build the devcontainer. This only needs to be done once, unless
new system dependencies are added:
```sh
$ scripts/devcontainer.sh build
```

Then, run the container:

```sh
$ scripts/devcontainer.sh run
```

This puts you in a bash shell at the root of the project, with your
development directory bind-mounted in the container. From there, you
can follow the instructions for [building locally](#building-locally)

# Using nix-shell

If you have Nix installed, a simple `nix-shell` will create the
necessary environment to build, with all system requirements
installed. This is detailed in the file [shell.nix](./shell.nix).
