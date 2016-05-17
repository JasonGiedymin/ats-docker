#!/bin/bash

set -e

COMMAND=${1:-usage}
BUILD_LOC=${BUILD_LOC:-/trafficserver}
ATS_BRANCH=devel
PREFIX=${PREFIX:-/usr/local}
CCACHE_OPT=""
MAKE_OPT=""

function log() {
  printf "%s $1\n" "-->"
}

function clone() {
  log "cloning repo"
  git clone --branch $1 https://github.com/apache/trafficserver.git .
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
  ./configure --prefix=$PREFIX $CCACHE_OPT
  make $MAKE_OPT
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
  sed -i "1i$header" ./proxy/config/records.config.default
}

function fixSharedLibUserSwitching() {
cat << EOF >> ./proxy/config/records.config.default

##############################################################################
# Docker CMD runs traffic_cop, user switching to other daemons required
# disabling. For a more secure system consider supplying your own configs and
# further modify the container with finite permissions.
##############################################################################
CONFIG proxy.config.admin.user_id STRING #-1

EOF
}

function run() {
  log "Running traffic server via traffic_cop..."
  $(/usr/local/bin/traffic_cop &) && sleep 15 && tail -f /usr/local/var/log/trafficserver/*
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
  -b --branch   : specify a specific branch. Used for 'build' command. Default=$ATS_BRANCH
  -c --ccache   : specify whether to use ccache or not
  -p --parallel : specify whether to use parallel tasks for make

EOF
}

function buildParse() {
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
      build
      fingerprint "devel"
      fixSharedLibUserSwitching
      install
      ;;
    *)
      # must be a branch then
      clone $ATS_BRANCH
      # checkout # don't use unless forcing, see clone above
      submodules
      build
      fingerprint $(githash)
      fixSharedLibUserSwitching
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
        -c*|--ccache*)
          CCACHE_OPT="--enable-ccache"
          ;;
        -p*|--parallel*)
          MAKE_OPT="-j"
          ;;
        *)
          ;;
    esac
  done
}

case $COMMAND in
  usage)
    usage
    parse "$@"
    ;;
  build)
    shift
    ccache -s
    parse "$@"
    buildParse
    ccache -s
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
