#!/bin/bash

# By default devel docker is specified.
# devel is a build from whatever is in
# the trafficserver directory.
ATS_DOCKER_TAG=${ATS_DOCKER_TAG:-devel}

time docker build --rm -t ats:$ATS_DOCKER_TAG .
