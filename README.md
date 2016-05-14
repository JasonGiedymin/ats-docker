# ats-docker
Apache TrafficServer Dockerfiles

## Goals

TODO:

  - [x] base image should have cloned repo
  - [x] modify template to use above new base image
  - [x] ccache
  - [ ] one image for base
    - [ ] build it
  - [ ] one image for building
  - [ ] same image for running
  - [ ] same image but hardcopy the version

## TLDR

```bash
# Build images first
bash build.sh # builds base, devel (local repo), and master (master repo)

# Run containers
bash run.sh devel # runs devel (local dev repo ./trafficserver)
# OR
bash run.sh tag master # runs master
# OR with mounted config files which are in ./configs
bash run.sh devel -m
# OR
bash run.sh tag master -m

# See Logs of running container
docker logs <container id from after running the above>

# Thats it!
```

## Building

### All

To build all the repos use the script `build.sh`. Within that script
is usage to build specific branches.

#### Specific

These specific commands will build specific images.

1. base image - `bash docker-driver.sh base`
1. current dev (local) - `bash docker-driver.sh devel`
1. specific branch - `bash docker-driver.sh branch master`

## Running

To run a container use the `run.sh` script provided. For usage type
`bash run.sh usage`. The usage display will also try to show configurable
option.

To run the devel container (which uses your local trafficserver directory), type
`bash run.sh devel`.

To run the devel container but mount a provided config, type
`bash run.sh -m devel`

Other commands available are `devel` and `tag`.

To run a specific tag with config mounts: `bash run.sh -m tag master`

To detach from a running container in console mode:
```bash
ctrl+pq
```

### Debugging

Once a container is running you may find it useful to connect with it.
If using docker, you can use the following command:

  docker exec -it <container-id> bash

Copying resources from the container:

  docker cp <containerId>:/file/path/within/container /host/path/target


## FAQ

Below are common docker issues.

1. How do I fix "error while loading shared libraries" when running trafficserver?
  * There are two things you'll want to do.
  * First make sure `LD_LIBRARY_PATH` is set. If it isn't run:
  ```bash
  # fyi, this is already specified in the dockerfile
  export LD_LIBRARY_PATH=/usr/local/lib
  ```
  * If that still doesn't work you may need to run docker using the device-mapper storage engine.
    - Run the following commands:
    ```bash
    # If using boot2docker
    boot2docker ssh

    # Add the new storage engine
    echo 'EXTRA_ARGS="--storage-driver=devicemapper"' >> /var/lib/boot2docker/profile

    # note that sometimes restart doesn't work and you may have to try and
    # stop and/or kill the pid, then start the daemon.
    sudo /etc/init.d/docker restart
    ```

  * *NOTE*: please note that traffic_cop will switch users and the ENV var will not be
    carried over.
