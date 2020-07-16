# Build libre
ARG LIBRE_VER="v0.4.16"
ARG LIBRE_REPO=https://github.com/creytiv/re.git

RUN git clone ${LIBRE_REPO} && \
    cd re && \
    git checkout ${LIBRE_VER} && \
    make SYSROOT_ALT="/usr" RELEASE=1 && \
    ifelse(BUILD_DEV,enabled,make install SYSROOT_ALT="/usr" RELEASE=1 PREFIX="/usr" && \
    make SYSROOT_ALT="/home/build/usr" RELEASE=1 && \
    make install SYSROOT_ALT="/home/build/usr" RELEASE=1 PREFIX="/home/build/usr",make install SYSROOT_ALT="/usr" RELEASE=1 PREFIX="/usr")
