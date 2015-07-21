#!/bin/bash

set -e

BUILD_LOC=${BUILD_LOC:-/trafficserver}
ATS_BRANCH=${1:-devel}
PREFIX=${PREFIX:-/usr/local}

pushd $BUILD_LOC

function clone() {
  git clone https://github.com/apache/trafficserver.git .
}

function checkout() {
  git checkout $1
}

function submodules() {
  git submodule init
  git submodule update
}

function build() {
  autoreconf -if
  ./configure --prefix=$PREFIX
  make
}

function install() {
  sudo make install
}

case $ATS_BRANCH in
  devel)
    # expected that source is provided at this point
    # run a test to be sure
    if ! [ -e configure.ac ]; then
      echo "Source not present for devel. Could not find autoconf file 'configure.ac'."
      exit 1
    fi
    ;;
  *)
    # must be a branch
    clone
    checkout $ATS_BRANCH
    submodules
    build
    ;;
esac

popd
