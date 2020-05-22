#!/usr/bin/env bash

config()
{

    ARGS=()

    ARGS+=("-DCMAKE_INSTALL_PREFIX=${PREFIX}")

    # Remove mysql-test directory (~330 MB) to reduce installation size
    ARGS+=("-DINSTALL_MYSQLTESTDIR=")

    # TokuDB requires third-party software jemalloci (see http://www.canonware.com/jemalloc/)
    ARGS+=('-DPLUGIN_TOKUDB=NO')

    # Due to cmake library discovery being overly energetic (searching every
    # lib directory relative to each entry in $PATH) we use the bundled ZLIB and
    # PCRE libraries to avoid link confusion downstream
    ARGS+=('-DWITH_ZLIB=bundled')
    ARGS+=('-DWITH_PCRE=bundled')

    # Prevent CMake from finding and linking against libraries distributed in $(dirname
    # python)/../lib. This is CMake's default behavior, but can cause us to erroneously link
    # against libraries distributed by e.g. Anaconda.
    # PYTHONLIBDIR=$(which python | sed -e's|bin/python|lib|')
    # ARGS+=("-DCMAKE_SYSTEM_IGNORE_PATH=${PYTHONLIBDIR}")

    # Client only, please, for this package
    ARGS+=('-DWITHOUT_SERVER=ON')

    cmake . "${ARGS[@]}"
}
