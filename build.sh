#!/bin/bash
# This script builds all desired images.
# If you request a specific image or branch use the
# docker-driver.sh manually (see below for examples)

set -e

bash docker-driver.sh base # base image
bash docker-driver.sh devel # current dev image
bash docker-driver.sh branch master # current master image
