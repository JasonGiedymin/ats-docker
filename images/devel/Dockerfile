FROM ats:devel
MAINTAINER apache-traffic-server

# Volumes
VOLUME /ccache
VOLUME /usr/local/etc/trafficserver

# Environment
ENV BUILD_LOC /trafficserver
ENV PREFIX /usr/local
ENV LD_LIBRARY_PATH /usr/local/lib

# Disable ccache for official images
ENV CCACHE_DISABLE 1

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

# Snapshot dir
RUN mkdir -p /usr/local/etc/trafficserver/snapshots

# Add Dockerfile for reference
ADD ./Dockerfile /Dockerfile
ADD ./configs /usr/local/etc/trafficserver

# Copy entrypoint, set perms
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Build devel
RUN bash /docker-entrypoint.sh build -b="devel"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["run"]
