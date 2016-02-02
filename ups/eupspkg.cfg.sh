# EupsPkg config file. Sourced by 'eupspkg'

config()
{
    # Disable external SSL on OS X as it is not a standard library
    # and LSST does not need full SSL support.
    ssloptions=""
    if [[ $(uname) == Darwin ]]; then
        ssloptions="-DWITH_SSL=bundled"
    fi

    # TokuDB requires third-party software jemalloci (see http://www.canonware.com/jemalloc/)
    cmake . -DCMAKE_INSTALL_PREFIX=${PREFIX} -DPLUGIN_TOKUDB=NO $ssloptions -DWITHOUT_SERVER=ON
}
