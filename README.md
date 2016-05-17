# ats-docker
Apache TrafficServer Dockerfiles

## Goals

1. Provide a repeatable and optimized, build/test (CI) environment
1. Provide "official" images
  a. without relying on interim containers
  b. that can be runnable
1. Provide helper scripts along the way

Note: helper scripts are provided, but ultimately they simply either help manage
building of artifacts or doing container/image maintenance.


## TLDR

```bash
# Builds and runs all CI images
bash build.sh # builds base, devel (local repo), and master (master repo)

# Build an official images
pushd images; bash build-official.sh all; popd

# Running the latest- see run.sh
bash run.sh tag 6.1.1
```

## Building

Building images for CI, development and testing are done with the `build.sh` script.

Note that the images contained in the `images/` directory are "official images"
(ones which are tagged and built without cache or layering). More on that later.

All CI images are prefixed with `ats`. So for example, building master would be
tagged as `ats:master` by the helper scripts.

### All

To build all the base images use the script `build.sh`. Within that script
is usage to build specific branches that will be layered.

#### Specific

These specific commands will build specific images, by using the `docker-driver.sh`
script. This script is what is referenced within the `build.sh` script.

1. base image - `bash docker-driver.sh base`
1. source image - `bash docker-driver.sh source "6.1.1"`
1. current dev (local) - `bash docker-driver.sh devel`
1. specific branch - `bash docker-driver.sh branch master`


## Official Images

To build any of the official containers, see the `images/build-official.sh`.
These are the images referenced by the `run.sh` script.

Official images are prefixed as `trafficserver`. So for example, release 6.1.1
would show up as `trafficserver:6.1.1`.

This is in contrast to the development images which are prefixed with `ats`.

## Running

To run a container, use the `run.sh` script provided. For usage type
`bash run.sh usage`. The usage display will also try to show configurable
option.

This script has only runs containers based on official images you build.

To run the devel container (which uses your local trafficserver directory), type
`bash run.sh devel`. This of course means you would have built the devel image
in the first place.

To run the devel container but mount a provided config, type
`bash run.sh -m devel`

To run a specific tag with config mounts: `bash run.sh -m tag master`

To detach from a running container in console mode:
```bash
ctrl+pq
```

To see logs of running container `docker logs <container id from after running the above>`.

### Run Notes

The provided run script will run images who's owner are `trafficserver` but
allows specifying a tag or the local devel branch of the source. Note that
in order to build images with `trafficserver` as the owner, you must build
an image from the `images/` directory. These are "official" images.


### Debugging

Once a container is running you may find it useful to connect with it.
If using docker, you can use the following command:

  docker exec -it <container-id> bash

Copying resources from the container:

  docker cp <containerId>:/file/path/within/container /host/path/target


## CI

There are several workflows to which these images were made for. They are:

  - building code from a specific branch remotely - use `build.sh`
  - building code (on one's hdd) locally - use `build.sh`
  - a managed config (within source) for repeatable official images (docker-esque via hub) - use `build-official.sh` and follow convention
  - running an image - use `run.sh` and follow convention

### Examples

#### Devel

First build all the necessary images. Next, dive down into the images directory and run the official build. Follow up with running the image.

```shell
bash build.sh # builds all the base images - this takes time but happens only once
pushd images
bash build-official.sh version devel # builds devel
bash run.sh devel # runs devel
docker run -it --entrypoint=/bin/bash trafficserver:devel
popd
```

## Development

### New Image Releases

1. create a new version under `images/`
1. copy the current `scripts/ats.sh` as `images/<your new version>/docker-entrypoint.sh`
1. copy/modify the your desired dockerfile, preferably one from a previous RC or a reified
version of a build template. If you chose a template, make sure to specify `-b="<your new version>"`

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
