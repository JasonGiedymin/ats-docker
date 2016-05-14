#!/bin/bash
# This script builds all desired images.
# If you request a specific image or branch use the
# docker-driver.sh manually (see below for examples)

set -e

time bash docker-driver.sh base # build base image
time bash docker-driver.sh source "6.1.1" # base source image
time bash docker-driver.sh branch master # current master image running on top of source
time bash docker-driver.sh devel # current dev image
