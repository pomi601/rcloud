#!/bin/bash

set -euo pipefail

library=""
package=""

scan(){
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l | --library )
                library="$2"
                shift
                ;;
            -* )
                ;;

            * )
                package="$1"
                ;;
        esac
        shift
    done
}

scan "$@"

# package could be a .tar.gz file, or a directory

if [[ -f "$package" ]]; then
    # get the stem of the tarball, which is the library name (by
    # convention) and will correspond to the library installation
    # directory.
    base="$(basename "$package")"
    stem="${base%_*}"
elif [[ -d "$package" ]]; then
    stem="$(grep Package: "$package/DESCRIPTION" |sed -e 's/.*: //')"
fi

libpath="$library/$stem"

# check if there's already a library installed in the destination
# directory, by looking for a DESCRIPTION file as a sentinel. If the
# sentinel is newer than the tarball, we don't need to build.
sentinel="$libpath/DESCRIPTION"
if [[ -f "$package" && -f "$sentinel" && "$sentinel" -nt "$package" ]]; then
    exit 0
elif [[ -d "$package" && -f "$sentinel" && "$sentinel" -nt "$package/DESCRIPTION" ]]; then
    exit 0
else

    # actually do the install

    # but first, check if there's a nonexecutable configure file
    # (looking at you, openssl)
    if [[ -d "$package" && -f "$package/configure" && ! -x "$package/configure" ]]; then
        chmod +x "$package/configure"
    fi

    if ! R CMD INSTALL "$@"; then
        err=$?
        echo "ERROR: $0: failed to R CMD INSTALL $package" >&2
        exit $err
    fi
fi
