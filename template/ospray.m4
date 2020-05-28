#build ospray

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libglfw-dev libgl1-mesa-dri libxrandr-dev  libxinerama-dev libxcursor-dev  && \
apt-get clean	&& \
rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libglfw3-dev libgl1-mesa-dri libxrandr-dev  libxinerama-dev libxcursor-dev  && \
apt-get clean	&& \
rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q glfw-devel mesa-dri-drivers
)dnl

ARG OSPRAY_VER=c42a885
ARG OSPRAY_REPO=https://github.com/ospray/ospray.git
RUN git clone ${OSPRAY_REPO} && \
    mkdir ospray/build && \
    cd ospray/build && \
    git checkout ${OSPRAY_VER} && \
    cmake .. && \
    make -j 8
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ospray/build
