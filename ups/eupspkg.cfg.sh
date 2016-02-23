#!/usr/bin/env bash

config()
{

    ARGS=()

    ARGS+=("-DCMAKE_INSTALL_PREFIX=${PREFIX}")
    # TokuDB requires third-party software jemalloci (see http://www.canonware.com/jemalloc/)
    ARGS+=('-DPLUGIN_TOKUDB=NO')

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
            # Disable external SSL on OS X as it is not a standard library
            # and LSST does not need full SSL support.
            ARGS+=('-DWITH_SSL=bundled')
            ;;
        *)
            # non-fatal
            echo "unsupported platform: $(uname)"
            ;;
    esac

    ARGS+=('-DWITHOUT_SERVER=ON')

    cmake . "${ARGS[@]}"
}
