# Build Linux kernel
ARG QAT_KERNEL_VER=4.9.210
ARG QAT_KERNEL_SOURCE_REPO=https://cdn.kernel.org/pub/linux/kernel

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libelf-dev bc libssl-dev libudev-dev
)ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q elf-devel bc openssl-dev udev-devel
)dnl

RUN wget -O - ${QAT_KERNEL_SOURCE_REPO}/v${QAT_KERNEL_VER%%.*}.x/linux-${QAT_KERNEL_VER}.tar.xz | tar xJ && \
    cd linux-${QAT_KERNEL_VER} && \
    make olddefconfig && \
    sed -i 's/.* CONFIG_CRYPTO_SHA512 .*/CONFIG_CRYPTO_SHA512=y/' .config && \
    sed -i 's/.* CONFIG_UIO .*/CONFIG_UIO=y/' .config && \
    yes "" | make -j8 && \
    yes "" | make -j8 modules;

