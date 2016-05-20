# It is important to know that this debug image starts
# with the devel image in the same `images/` dir

FROM trafficserver:devel
MAINTAINER apache-traffic-server

# Volumes
VOLUME /ccache
VOLUME /usr/local/etc/trafficserver

# Environment
ENV BUILD_LOC /trafficserver

# Set working dir
WORKDIR $BUILD_LOC

RUN sudo apt-get install -y vim

RUN sudo chown root:root /usr/local/var/log/trafficserver

# USER nobody

# Add Dockerfile for reference
ADD ./Dockerfile /Dockerfile

# Copy entrypoint, set perms
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["run"]
