#!/bin/bash

set -e

spinner()
{
	local pid=$1
	local delay=0.75
	local spinstr='.'
	while ps -p "$pid" | grep -q "$pid"; do
		echo -n "$spinstr"
		sleep $delay
	done
	echo
}

SRC_DIR=/home/qserv/src

. /qserv/stack/loadLSST.bash

setup git 1.8.5.2

cp -r /tmp/mariadb $SRC_DIR
cd "$SRC_DIR/mariadb"
setup -r .
eupspkg -e prep
for cmd in config build install
do
    echo "eupspkg step: $cmd"
	(eupspkg -e "$cmd" > /tmp/"$cmd".log 2>&1) &
	my_pid=$!
	spinner "$my_pid"
	wait "$my_pid"
	ret_code=$?
    if [ $ret_code -ne 0 ]; then
		cat /tmp/"$cmd".log
		exit 1
    fi
done
eupspkg -e decl -t current
