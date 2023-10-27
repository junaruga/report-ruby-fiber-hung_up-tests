#!/bin/bash

set -eux

export NPROC="$(nproc)"
export JOBS=-j$((1+${NPROC}))
export SETARCH=
# -O1 is faster than -O3 in our tests.
export optflags=-O1
# -g0 disables backtraces when SEGV.  Do not set that.
export debugflags=-ggdb3
export RUBY_TESTOPTS="$JOBS -q --tty=no"
export CC=gcc-11

./autogen.sh
mkdir build
cd build
../configure -C --disable-install-doc --prefix=$(pwd)/install
make -s $JOBS
make -s $JOBS install
make -s test
make -s test-all RUBYOPT="-w"
