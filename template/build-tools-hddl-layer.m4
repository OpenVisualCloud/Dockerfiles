# BUILD TOOLS for HDDLDAEMON run layer image
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
ifelse(index(DOCKER_IMAGE,hddldaemon),-1,,dnl
RUN apt-get update && apt-get install -y sudo libboost-filesystem1.65-dev nasm libboost-thread1.65-dev libboost-program-options1.65-dev libjson-c-dev libusb-1.0-0 autoconf automake make libtool kmod libelf-dev lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
)dnl
)dnl
