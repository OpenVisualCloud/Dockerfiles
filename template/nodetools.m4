# Install node
ARG NODE_VER=v8.15.0
ARG NODE_REPO=https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-linux-x64.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends ca-certificates wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q ca-certificates wget xz-utils
)dnl

RUN wget ${NODE_REPO} && \
    tar xf node-${NODE_VER}-linux-x64.tar.xz && \
    cp node-*/* /usr/local -rf && \
    ifelse(BUILD_DEV,enabled,npm install -g --loglevel error node-gyp@v6.1.0 grunt-cli underscore jsdoc && rm -rf node-*, rm -rf node-*)
