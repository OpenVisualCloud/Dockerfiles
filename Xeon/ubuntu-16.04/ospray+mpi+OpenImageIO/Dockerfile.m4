
FROM ubuntu:16.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(ispc.m4)
include(embree.m4)
include(OpenImageIO.m4)
include(ospray-mpi.m4)
#include(ospray-example_san-miguel.m4)
#include(ospray-example_xfrog.m4)

FROM build
LABEL Description="This is the base image ospray-oiio-mpi Ubuntu 16.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home
