ARG PYTHON_VER=3.6.6
ARG PYTHON_REPO=https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel \
    readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
RUN wget -O - ${PYTHON_REPO} | tar xz && \
    cd Python-${PYTHON_VER} && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    make install DESTDIR=/home/build
RUN yum install -y -q python-yaml
,dnl
RUN apt-get install -y python3 python3-pip python3-setuptools python-yaml
)dnl

define(`INSTALL_PKGS_PYTHON', ifelse(index(DOCKER_IMAGE,ubuntu),-1, python-yaml , python3 python3-pip python-yaml ))dnl
