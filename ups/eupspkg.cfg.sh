#!/usr/bin/env bash

config()
{

    ARGS=()

    ARGS+=("-DCMAKE_INSTALL_PREFIX=${PREFIX}")
    # TokuDB requires third-party software jemalloci (see http://www.canonware.com/jemalloc/)
    ARGS+=('-DPLUGIN_TOKUDB=NO')

    # Due to cmake library discovery being overly energetic (searching every
    # lib directory relative to each entry in $PATH) we use the bundled SSL and
    # ZLIB libraries to avoid link confusion downstream

    ARGS+=('-DWITH_SSL=bundled')
    ARGS+=('-DWITH_ZLIB=bundled')
    ARGS+=('-DWITH_PCRE=bundled')

    case $(uname) in
        Linux*)
            ;;
        Darwin*)
            # No special arguments needed (must use bundled SSL)

            ;;
        *)
            # non-fatal
            echo "unsupported platform: $(uname)"
            ;;
    esac

    ARGS+=('-DWITHOUT_SERVER=ON')

    cmake . "${ARGS[@]}"
}
