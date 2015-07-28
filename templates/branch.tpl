FROM ats:base
MAINTAINER apache-traffic-server

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

# Build
RUN bash /ats.sh build -b=%s

# Run the service
CMD bash /ats.sh run
