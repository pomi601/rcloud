#!/bin/bash

set -euo pipefail

library=""
tarball=""

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
                tarball="$1"
                ;;
        esac
        shift
    done
}

scan "$@"

# get the stem of the tarball, which is the library name (by
# convention) and will correspond to the library installation
# directory.
base="$(basename "$tarball")"
stem="${base%_*}"

libpath="$library/$stem"

# check if there's already a library installed in the destination
# directory, by looking for a NAMESPACE file as a sentinel. If the
# sentinel is newer than the tarball, we don't need to build.
sentinel="$libpath/NAMESPACE"
if [[ -f "$sentinel" && "$sentinel" -nt "$tarball" ]]; then
    exit 0
else
    exec R CMD INSTALL "$@"
fi
