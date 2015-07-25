#!/bin/bash

set -e

COMMAND=${1:-usage}
BUILD_LOC=${BUILD_LOC:-/trafficserver}
ATS_BRANCH=devel
PREFIX=${PREFIX:-/usr/local}

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

function run() {
  log "Running traffic server via traffic_cop..."
  /usr/local/bin/traffic_cop
}

function usage() {
cat<<EOF

Usage:
  $0 <options> <command>

Commands:
  usage     : displays this usage screen
  build     : builds devel by default, unless branch (--branch) option specified
  run       : runs a currently installed trafficserver

Options:
  -b --branch  : specify a specific branch. Used for 'build' command. Default=$ATS_BRANCH

EOF
}

function build() {
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
}

function parse() {
  if [ ! -n "$0" ]; then
    echo "You passed the following options: $@"
  fi

  for i in "$@"
  do
    case $i in
        -b*|--branch*)
          ATS_BRANCH="${i#*=}"
          ;;
        *)
          ;;
    esac
  done
}

# pushd $BUILD_LOC

case $COMMAND in
  usage)
    usage
    parse "$@"
    ;;
  build)
    shift
    parse "$@"
    build
    ;;
  run)
    shift
    parse "$@"
    run
    ;;
  *)
    usage
    ;;
esac

# popd
