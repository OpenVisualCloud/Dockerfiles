include(envs.m4)
HIDE
define(`ENABLE_CENTOS_REPO',`dnl
RUN sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/CentOS-$1.repo
')
define(`INSTALL_CENTOS_REPO',`dnl
RUN yum install -y -q $1
')
define(`INSTALL_CENTOS_RPMFUSION_REPO',
RUN dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$1.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$1.noarch.rpm )dnl
define(`INSTALL_CENTOS_OKEY_REPO',
RUN dnf install -y http://repo.okay.com.mx/centos/$1/x86_64/release/okay-release-1-2.el$1.noarch.rpm )dnl
UNHIDE
