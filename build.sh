#!/bin/bash

set -e

bash docker-driver.sh base # base image
bash docker-driver.sh devel # current dev image
bash docker-driver.sh branch master # current master image
