FROM ats:source
MAINTAINER apache-traffic-server

# Volumes
VOLUME /ccache

# Add Dockerfile for reference
ADD ./_Dockerfile /Dockerfile

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

# clone
# RUN git clone https://github.com/apache/trafficserver.git .

# RUN git fetch origin

# RUN git checkout %s

# submodules
# RUN git submodule init
# RUN git submodule update

# Build
# RUN autoreconf -if
# RUN ./configure --prefix=$PREFIX --enable-ccache
# RUN make

# ccache stats
# RUN ccache -s

# Build
CMD bash /ats.sh build -b="%s"

# Run the service
# CMD bash /ats.sh run
