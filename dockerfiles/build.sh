#!/bin/bash

set -e

OWNER=ats
DOCKER_TAG=$1
DOCKERFILE=dockerfiles/$DOCKER_TAG/Dockerfile

echo "--> Building $OWNER:$DOCKER_TAG from $DOCKERFILE"

time docker build --rm -t $OWNER:$DOCKER_TAG -f $DOCKERFILE .

echo
echo "--> Completed $OWNER:$DOCKER_TAG"
echo
