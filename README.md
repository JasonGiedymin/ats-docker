# ats-docker
Apache TrafficServer Dockerfiles

## Building

### All

To build all the repos use the script `build.sh`. Within that script
is usage to build specific branches.

### Specific

These specific commands will build specific images.

1. base image - `bash docker-driver.sh base`
1. current dev (local) - `bash docker-driver.sh devel`
1. specific branch - `bash docker-driver.sh branch master`

### Debugging

Once a container is running you may find it useful to connect with it.
If using docker, you can use the following command:

  docker exec -it <container-id> bash
