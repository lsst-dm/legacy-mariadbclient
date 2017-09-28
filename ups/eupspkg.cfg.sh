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
            if grep -q -i "CentOS release 5" /etc/redhat-release; then
                # mroonga does not build on EL5 (conda ref platform) and is
                # unused by LSST
                ARGS+=('-DPLUGIN_MROONGA=NO')
                # required to build on EL5
                ARGS+=('-DHAVE_CXX_NEW=NO')
            fi
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
