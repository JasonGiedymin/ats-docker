#!/bin/bash

set -e

OWNER=${OWNER:-trafficserver}

build() {
  if [ ! $1 ]; then
    echo "Please specify the version to build."
    exit 1
  fi

  if [ ! -e $1 ]; then
    echo "Cannot find version '$1' at '$(pwd)/$1/', exiting."
    exit 1
  fi

  pushd $1
  
  set +e
  echo "Attempting removal of $OWNER:$1, otherwise moving on..."
  docker rmi $OWNER:$1

  set -e
  time docker build --rm -t $OWNER:$1 -f Dockerfile .
  popd
}

case $1 in
  all) # none of these builds should use ccache (see the repsective Dockerfile)
    build "6.1.0"
    build "6.1.1"
    ;;
  version)
    shift
    build $1
    ;;
  *)
    echo "$0 {all|version}"
    ;;
esac
