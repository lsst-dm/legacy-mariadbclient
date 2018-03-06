#!/usr/bin/env bash

config()
{

    ARGS=()

    ARGS+=("-DCMAKE_INSTALL_PREFIX=${PREFIX}")
    # TokuDB requires third-party software jemalloci (see http://www.canonware.com/jemalloc/)
    ARGS+=('-DPLUGIN_TOKUDB=NO')

    # Due to cmake library discovery being overly energetic (searching every
    # lib directory relative to each entry in $PATH) we use the bundled ZLIB
    # and PCRE libraries to avoid link confusion downstream

    ARGS+=('-DWITH_ZLIB=bundled')
    ARGS+=('-DWITH_PCRE=bundled')
    ARGS+=('-DWITHOUT_SERVER=ON')

    cmake . "${ARGS[@]}"
}
