# TODO

- [x] devel build (whatever is in `trafficserver/`)
- [x] dev build flags which take existing repo
- [x] dev repo flag which clones a fresh master copy
- [x] docker releases for every ats release:
  - [x] docker template files
  - [x] new driver script to:
    - [x] build base image
    - [x] build devel image
    - [x] build any branch
  - [x] remove previous image before building
- [x] config mounts:
  - [x] fingerprint config file `./proxy/config/records.config.default.in`
  - [x] devel
  - [x] master
- [x] expose ports
- [x] add all configs
- [x] Run script (traffic_cop)
- [x] Run with mounted configs
- [x] Add FAQ
- [x] Redo run but within ats and command parsing
- [x] Fix ATS script loop
- [x] On CMD run traffic_cop
- [x] On CMD also tail logs
- [x] On docker run expose all ports and detach

v0.2.5 - Run
- [x] FIX shared lib, due to user switching of TS daemons
  - [x] add to devel configs
  - [x] add `/usr/local/etc/trafficserver/snapshots` dir to base template
  - [x] add config param to ats command
  - [x] Readme note that to override, simply supply own configs
  - [x] move fingerprinting and user switching toggle to generated files prior to `make install`
        rather than using the template `.in` file.
- [x] Embed dockerfile

v0.3.0 - Build
- [x] base image should have cloned repo
- [x] modify template to use above new base image
- [x] ccache
- [x] images, modify docker-entry so that only run exits

v0.4.0 - Enhance
- [x] faster builds (cpu, cache, etc...)
- [x] build and run vet
- [x] parallel build flags
- [x] bring back devel
- [ ] fix weird tty background running issue 
- [ ] vet 6.x.x releases
- [ ] ccache data container option
- [ ] Run specifying a single remap config file
- [ ] Run Cache mount
- [ ] Better logging?
- [ ] gatling perf test
- [ ] docker compose?
- [ ] compose with logging framework?
- [ ] integration tests:
    - [ ] integration tests
    - [ ] Jenkins (repo supplied)
    - [ ] with GCE container engine
- [ ] kubernates pods/rc
- [ ] perf tuning docker
- [ ] production review
