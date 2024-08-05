AC_INIT([rcloud], m4_normalize(m4_include([VERSION])), [https://github.com/att/rcloud])
AC_PREREQ([2.71]) # in Debian bookworm
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

# generate error if PKG macros are not available
m4_pattern_forbid([^PKG])

# Enable warnings as errors, but we require GNU make, so disable
# portability warnings.
AM_INIT_AUTOMAKE([-Wall -Werror -Wno-portability tar-pax no-dependencies foreign])
AM_SILENT_RULES([yes])
AM_EXTRA_RECURSIVE_TARGETS([vendor-fetch] [vendor-copy] [vendor-install])

# we require GNU Make
AX_CHECK_GNU_MAKE([], [AC_MSG_ERROR([GNU Make required.])])

# define build var in makefiles, e.g. x86_64-linux-gnu
AC_CANONICAL_BUILD

AC_PROG_MKDIR_P
AC_PROG_CC

PKG_PROG_PKG_CONFIG

# git
AC_CHECK_PROG([GIT], [git], [git], [no])
AS_IF([test "$GIT" = "no"], [AC_MSG_ERROR([git required.])])

# r
AC_CHECK_PROG([R], [R], [R], [no])
AS_IF([test "$R" = "no"],
            [AC_MSG_ERROR([R required: install r-base-dev or similar.])])

# wget
AC_CHECK_PROG([WGET], [wget], [wget], [no])

# sha256sum
AC_CHECK_PROG([SHA256SUM], [sha256sum], [sha256sum], [no])
AS_IF([test "$SHA256SUM" = "no"],
            [AC_MSG_ERROR([sha256sum required: install coreutils or similar.])])

# openssl
AX_CHECK_OPENSSL([],
    [AC_MSG_ERROR([OpenSSL required: install libssl-dev or similar.])])

# libcurl
AC_CHECK_HEADERS([curl/curl.h], [], [AC_MSG_ERROR([curl/curl.h not found.])])
AC_CHECK_LIB([curl], [curl_easy_init], [], [AC_MSG_ERROR{libcurl required.}])

# cairo
PKG_CHECK_MODULES([CAIRO], [cairo >= 1.2], [],
                           [AC_MSG_ERROR([Cairo >= 1.2 required.])])

# icu: for stringi, otherwise it slowly compiles its own
AX_CHECK_ICU(61, [], [AC_MSG_ERROR[ICU required: install libicu-dev]])

AC_CONFIG_FILES([
    Makefile
    vendor/Makefile
])
AC_OUTPUT
