# COMMON BUILD TOOLS
ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;
,dnl
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3009
RUN apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev
)dnl

include(cmake.m4)
include(automake.m4)
ifdef(`BUILD_TOOLS_NO_ASM',,`dnl
include(nasm.m4)
include(yasm.m4)dnl
')dnl
