#!/bin/bash

set -e

bash dockerfiles/build.sh base
bash dockerfiles/build.sh devel
bash dockerfiles/build.sh master
