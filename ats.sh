#!/bin/bash

set -e

BUILD_LOC=${BUILD_LOC:-/trafficserver}
ATS_BRANCH=${1:-devel}
PREFIX=${PREFIX:-/usr/local}

pushd $BUILD_LOC

function log() {
  printf "%s $1\n" "-->"
}

function clone() {
  log "cloning repo"
  git clone https://github.com/apache/trafficserver.git .
}

function checkout() {
  log "switching to branch $1"
  git checkout $1
}

function submodules() {
  log "initializing submodules"
  git submodule init
  git submodule update
}

function build() {
  log "building source"
  autoreconf -if
  ./configure --prefix=$PREFIX
  make
}

function install() {
  log "installing..."
  sudo make install
}

function githash() {
  printf $(git rev-parse HEAD)
}

function fingerprint() {
  hash=$1
  log "fingerprinting records.config"
  header="##############################################################################\n# Commit: $hash"
  sed -i "1i$header" ./proxy/config/records.config.default.in
}

log "building branch $ATS_BRANCH"

case $ATS_BRANCH in
  devel)
    # expected that source is provided at this point
    # also expected that this is a development branch
    # and you've already initialized all submodules
    # run a test to be sure
    if ! [ -e configure.ac ]; then
      echo "Source not present for devel. Could not find autoconf file 'configure.ac'."
      exit 1
    fi
    fingerprint "devel"
    build
    install
    ;;
  *)
    # must be a branch
    clone
    checkout $ATS_BRANCH
    submodules
    fingerprint $(githash)
    build
    install
    ;;
esac

popd
