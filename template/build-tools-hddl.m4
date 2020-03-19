# BUILD TOOLS for HDDLDAEMON image
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
ifelse(index(DOCKER_IMAGE,hddldaemon),-1,,dnl
RUN apt-get update && apt-get install -y --no-install-recommends cpio sudo python3-pip python3-setuptools wget libboost-filesystem1.65 libboost-thread1.65 libboost-program-options1.65 libjson-c-dev build-essential autoconf automake libtool kmod libelf-dev libusb-1.0-0 lsb-release && \
    rm -rf /var/lib/apt/lists/*
)dnl
)dnl
