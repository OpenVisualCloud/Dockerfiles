#example for ospray "San Miguel" works only with OpenImageIO installed


ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends unzip	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q unzip
)dnl

ARG EXAMPLE_PATH=http://www.sdvis.org/ospray/download/demos/sanm.zip
ARG EXAMPLE_NAME=sanm.zip
ARG LIGHT_PATH=http://www.pauldebevec.com/Probes/rnl_probe.pfm
RUN mkdir example; \
    cd example; \
    wget ${LIGHT_PATH}; \
    wget ${EXAMPLE_PATH}; \
    unzip ${EXAMPLE_NAME}; \
    rm -f ${EXAMPLE_NAME}
