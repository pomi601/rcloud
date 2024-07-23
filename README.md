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

In order to build rcloud, these tarballs must be fetched using a
special `make` target prior to building.

# Building locally

Assuming you have just cloned the repository, do the following:

```sh
$ autoreconf --install
$ mkdir build && cd build
$ ../configure
$ make vendor-fetch
$ make
$ (sudo) make install
```

## Configure rcloud and rserve

Ensure the files `conf/rcloud.conf` and `conf/rserve.conf` are
correct. Reference `rcloud.conf.docker` and `rserve.conf.docker` for a
working example that is used by the docker image.

## Running

Start the redis server:

```sh
$ redis-server &
```

Set up correct isolated R package environment:

```sh
$ export R_LIBS_USER=/usr/local/lib/rcloud/site-library
```

Start rserve and rcloud:

```sh
$ sh conf/start
```

## Edit - compile - run

Subsequently, to rebuild only what is necessary and to run the
service, it is more convenient to use an uninstalled R package
library:

```sh
export R_LIBS_USER=`cd build/out/lib && pwd`
```

And then:

```sh
$ make
$ sh conf/start
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
