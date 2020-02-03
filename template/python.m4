ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel \
    readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel python36
RUN yum install -y -q python-yaml
,dnl
RUN apt-get update && apt-get install -y python3 python3-pip python3-setuptools python3-yaml
)dnl

define(`INSTALL_PKGS_PYTHON', ifelse(index(DOCKER_IMAGE,ubuntu),-1, python-yaml , python3 python3-yaml ))dnl

