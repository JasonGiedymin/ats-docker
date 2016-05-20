#!/bin/bash
# This script builds all desired images and runs them.
# It is during the run step which will build the source.
# If you request a specific image or branch use the
# docker-driver.sh manually (see below for examples)

# docker rm $( docker ps -a | tr -s ' ' | cut -d ' ' -f 1) # all exited containers
docker rm $( docker ps -aq | tr -s ' ' | cut -d ' ' -f 1) # all exited containers
docker rm $( docker ps -a | grep 'trafficserver' | tr -s ' ' | cut -d ' ' -f 1)
docker rm $( docker ps -a | grep 'ats' | tr -s ' ' | cut -d ' ' -f 1)
# docker rm $(docker ps -a | grep "trafficserver.*devel.*" | tr -s ' ' | cut -d ' ' -f 1)
docker rmi $( docker images | grep 'trafficserver' | tr -s ' ' | cut -d ' ' -f 3)
docker rmi $( docker images | grep 'ats' | tr -s ' ' | cut -d ' ' -f 3)
# docker rmi $( docker images | grep "ats.*devel.*" | tr -s ' ' | cut -d ' ' -f 3)
docker rmi $( docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)


set -e

[ ! -e ./ccache ] && mkdir ./ccache

pushd scripts
time bash docker-driver.sh base # build base image
time bash docker-driver.sh source "6.1.1" # base source image
time bash docker-driver.sh branch master # current master image running on top of source
time bash docker-driver.sh devel # current dev image

# as an example, here we build a very specific version, one which will get
# tagged (`docker images | grep "ats.*6.0.0"` )
time bash docker-driver.sh branch "6.0.0" # build an older image
popd
