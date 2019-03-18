# Build Linux kernel
ARG QAT_KERNEL_SOURCE_REPO=https://cdn.kernel.org/pub/linux/kernel

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libelf-dev bc libssl-dev libudev-dev
)ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q elf-devel bc openssl-dev udev-devel
)dnl

RUN kernel_version=$(cat /proc/version | cut -f3 -d' ') && \
    wget -O - ${QAT_KERNEL_SOURCE_REPO}/v${kernel_version%%.*}.x/linux-${kernel_version}.tar.xz | tar xJ && \
    cd linux-${kernel_version} && \
    make olddefconfig && \
    sed -i 's/.* CONFIG_CRYPTO_SHA512 .*/CONFIG_CRYPTO_SHA512=y/' .config && \
    sed -i 's/.* CONFIG_UIO .*/CONFIG_UIO=y/' .config && \
    yes "" | make -j8 && \
    yes "" | make -j8 modules;

# Build the QAT Driver
ARG QAT_DRIVER_VER=1.7.l.4.3.0-00033
ARG QAT_DRIVER_REPO=https://01.org/sites/default/files/downloads/intelr-quickassist-technology/qat${QAT_DRIVER_VER}.tar.gz

RUN kernel_version=$(cat /proc/version | cut -f3 -d' ') && \
    mkdir qat-driver && \
    cd qat-driver && \
    wget -O - ${QAT_DRIVER_REPO} | tar xz && \
    KERNEL_SOURCE_ROOT=/home/linux-${kernel_version} ./configure --prefix=/opt/qat && \
    sed -i 's/rdtscll(timestamp)//' quickassist/utilities/osal/src/linux/kernel_space/OsalServices.c && \
    make -j8;
