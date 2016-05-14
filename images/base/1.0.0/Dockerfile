FROM ubuntu
MAINTAINER apache-traffic-server

# Volumes
VOLUME /ccache

# Environment
ENV BUILD_LOC /trafficserver
ENV PREFIX /usr/local
ENV LD_LIBRARY_PATH /usr/local/lib

# Set working dir
WORKDIR $BUILD_LOC

# proxy port     - proxy.config.http.server_ports
EXPOSE 8080

# cluster port   - proxy.config.cluster.cluster_port
EXPOSE 8086

# cluster rsport - proxy.config.cluster.rsport
EXPOSE 8088

# cluster mcport - proxy.config.cluster.mcport
EXPOSE 8089

# connect ports  - proxy.config.http.connect_ports
EXPOSE 443

# connect ports  - proxy.config.http.connect_ports
EXPOSE 563


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

# Add Dockerfile for reference
ADD ./Dockerfile /Dockerfile

# Add helper
# ADD ./ats.sh /ats.sh

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
