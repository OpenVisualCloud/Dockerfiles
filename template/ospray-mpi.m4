#build ospray

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libglfw-dev libgl1-mesa-dri libxrandr-dev  libxinerama-dev libxcursor-dev libmpich-dev mpich openssh-server openssh-client	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libglfw3-dev libgl1-mesa-dri libxrandr-dev  libxinerama-dev libxcursor-dev libmpich-dev mpich openssh-server openssh-client	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q glfw-devel mesa-dri-drivers mpich-devel openssh-server openssh-clients
)dnl

ENV PATH=$PATH:/usr/lib64/mpich/bin

ARG OSPRAY_VER=c42a885
ARG OSPRAY_REPO=https://github.com/ospray/ospray.git
RUN git clone ${OSPRAY_REPO}; \
    mkdir ospray/build; \
    cd ospray/build; \
    git checkout ${OSPRAY_VER}; \
    cmake .. -DOSPRAY_MODULE_MPI=ON -DOSPRAY_SG_OPENIMAGEIO=ON; \
    make -j 8
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ospray/build

RUN mkdir -p /var/run/sshd; \
    sed -i 's/^#Port/Port/g' /etc/ssh/sshd_config; \
    sed -i 's/^Port 22/Port 2222/g' /etc/ssh/sshd_config; \
    sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config; \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config; \
    sed -i 's/#   Port 22/Port 2222/g' /etc/ssh/ssh_config; \
    echo 'root:ospray' |chpasswd; \
    /usr/sbin/sshd-keygen; \
    sed -i 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/g' /etc/ssh/ssh_config; \
    /usr/bin/ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa; \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
