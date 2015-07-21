#!/bin/bash

#
# Basic Docker Driver to generate images dynamically
# This script is meant to be used in an automated
# fashion
#
# Author: Jason Giedymin <jasong@apache.org>

#
# == SETUP ==
#
set -e

OWNER=${OWNER:-ats}
DOCKERFILE=_Dockerfile
IMAGE=$1
TAG=$2

_DOCKER_HOST=$(echo $DOCKER_HOST | awk -F "//" '{print $2}')
HOST=${_DOCKER_HOST:-$(boot2docker ip)} # we will assume boot2docker unless told otherwise

#
# == Methods ==
#

function checkTag() {
  if [ -z $TAG ]; then
    echo "You must specify a tag."
    echo "  $0 <image> <tag>"
    exit 2
  fi
}

# Test requirements of the app
function testReqs() {
  if [ -z $HOST ]; then
    echo "Please supply the 'DOCKER_HOST' environment variable."
    exit 1
  fi
}

# Show info about the script
function info() {
  echo "Using docker host: [$HOST]"
}

# Run the build
function build() {
  printf "\n\n--> Building $OWNER:$TAG from $DOCKERFILE\n"

  docker build --rm -t $OWNER:$TAG -f $DOCKERFILE .

  printf "\n--> Completed $OWNER:$TAG\n"
}

function generateDockerfile() {
  local tempDockerfile=_Dockerfile
  local branch=$1.tpl
  local file=$(< templates/$branch)
  printf "\n---------------Dockerfile---------------\n"
  printf "$file" $TAG | tee $DOCKERFILE
  printf "\n----------------------------------------\n"
}

function remove() {
  printf "%s Removing any older images matching %s:%s..." "-->" $OWNER $TAG
  # _if_ you prefer grep for matching, use the below (i.e. you want to change it)
  # local pattern="^$OWNER.*$TAG"
  # local images=$(docker images | grep "$pattern" -A0 --color=never | awk "{print \$3}")

  local pattern="/^$OWNER.*$TAG/"
  local images=$(docker images | awk "$pattern { print \$3 }")
  if [ ! -z "$images" ]; then
    printf "found some, removing...\n"
    docker rmi -f $images
  else
    printf "none to remove\n"
  fi;
}

function main() {
  case "$IMAGE" in
    branch)
      testReqs
      checkTag
      info
      generateDockerfile branch
      remove
      build # remember base relies on $TAG
      ;;
    devel)
      TAG=devel
      testReqs
      info
      generateDockerfile devel
      remove
      build # remember base relies on $TAG
      ;;
    base)
      TAG=base
      testReqs
      info
      generateDockerfile base
      remove
      build # remember base relies on $TAG
      ;;
  esac
}

main
