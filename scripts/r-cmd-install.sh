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
else
    echo "ERROR: $0: Invalid package argument: $package"
    exit 1
fi

libpath="$library/$stem"

# check if any file in the package directory is newer than the
# DESCRIPTION file in the installed library directory, and rebuild if
# so.
#
# We do this to make our build system configuration easier. Otherwise,
# we would have to explicitly list every source file in our system.
rebuild="no"
if [[ -f "$package" ]]; then
    rebuild="yes"
elif [[ ! -d "$libpath" ]]; then
    rebuild="yes"
else
    # both package and libpath are existant directories
    files=$(find "$package" -type f)
    for file1 in $files; do
        # # get relative path inside $package dir
        # relpath="${file1#"$package/"}"

        # # get corresponding file in $libpath
        # file2="$libpath/$relpath"

        file2="$libpath/DESCRIPTION"

        if [[ ! -e "$file2" ]]; then
            echo "REBUILD: no DESCRIPTION file found in destination: $stem: $package $libpath"
            rebuild="yes"
            break
        else
            mtime1=$(stat -c %Y "$file1")
            mtime2=$(stat -c %Y "$file2")

            # echo "Checking $file1 $mtime1 vs $mtime2 ..."
            # Due to problems with subsecond accuracy, subtract 1
            # second from mtime1 to avoid unnecessary rebuilds except
            # in the extreme case.
            mtime1="$((mtime1-1))"

            if [[ "$mtime1" -gt "$mtime2" ]]; then
                echo "REBUILD: NEWER file found in source: $stem: $package $libpath $file1 $mtime1 $file2 $mtime2"
                rebuild="yes"
                break
            fi
        fi
    done
fi


if [[ "$rebuild" == "yes" ]]; then
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
    else
        # touch every installed file to fix up modification dates
        files=$(find "$libpath" -type f)
        for file in $files; do
            touch "$file"
        done
    fi
fi
