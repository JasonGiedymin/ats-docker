FROM ubuntu
MAINTAINER apache-traffic-server

# Volumes
VOLUME /ccache
VOLUME /usr/local/etc/trafficserver

# Environment
ENV BUILD_LOC /trafficserver
ENV PREFIX /usr/local
ENV LD_LIBRARY_PATH /usr/local/lib

# Set working dir
WORKDIR $BUILD_LOC

# Install reqs
RUN sudo apt-get update
RUN sudo apt-get -y install software-properties-common
RUN sudo add-apt-repository universe
RUN sudo apt-get install -y gcc g++ automake autoconf libtool \
pkg-config libssl-dev tcl-dev libexpat1-dev libpcre3-dev \
libhwloc-dev libcurl3-dev libncurses5-dev libaio-dev libcap-dev \
libcap2 bison flex make libmodule-install-perl libunwind8-dev \
git

# Install extras
RUN sudo apt-get install -y gdb valgrind git ack-grep curl \
tmux screen ccache python-sphinx doxygen python-lxml

# Enable ccache
ENV PATH "/usr/lib/ccache:$PATH"
ENV CCACHE_DIR /ccache/

RUN ccache -F 0 && ccache -M 0

# Snapshot dir
RUN mkdir -p /usr/local/etc/trafficserver/snapshots

# Add helper
ADD ./scripts/ats.sh /ats.sh

# Add Dockerfile for reference
ADD ./_Dockerfile /Dockerfile
