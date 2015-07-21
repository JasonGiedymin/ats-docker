FROM ats:base
MAINTAINER apache-traffic-server

ADD ./trafficserver $BUILD_LOC

# Build
RUN bash /ats.sh
