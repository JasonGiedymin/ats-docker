#!/bin/bash

COMMAND=${1:-usage}
TAG=${2:-devel}
LOCAL_CONFIG=/configs # this will be appended, this is not a fully qualified path
# DOCKER_CONFIG=/trafficserver/proxy/config/records.config.default.in
DOCKER_CONFIG=/usr/local/etc/trafficserver
MOUNT_OPTS="-v $(PWD)$LOCAL_CONFIG:$DOCKER_CONFIG"
USE_MOUNT=${USE_MOUNT:false}

function checkTag() {
  if [ -z $TAG ]; then
    echo "You must specify a tag."
    echo "  $0 <tag>"
    exit 2
  fi
}

function runWithMount() {
  local image=ats:$1
  echo "running $image with mounted volumes..."

  docker run -ditP $MOUNT_OPTS $image
}

function runWithoutMount() {
  local image=ats:$1
  echo "running $image..."

  docker run -ditP $image
}

function run() {
  if ! [ $USE_MOUNT ]; then
    runWithoutMount $1
  else
    runWithMount $1
  fi
}

function usage() {
cat<<EOF

Usage:
  $0 <command> <command-options>

Commands:
  usage          : displays this usage screen
  devel          : builds devel
  tag <some_tag> : builds some user specified tag

Tag Options:
  -m --mount     : uses mount as specified by MOUNT_OPTS. Override if nessary.
                   MOUNT_OPTS="$MOUNT_OPTS"

EOF
}

function parse() {
  if [ ! -n "$0" ]; then
    echo "You passed the following options: $@"
  fi

  for i in "$@"
  do
    case $i in
        -m*|--mount*)
          # USE_MOUNT="${i#*=}"
          USE_MOUNT=true
          ;;
        # -t=*|--tag=*)
        #   TAG="${i#*=}"
        #   ;;
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
  devel)
    shift
    parse "$@"
    run devel
    ;;
  tag)
    shift 2
    parse "$@"
    run $TAG
    ;;
  *)
    usage
    ;;
esac
