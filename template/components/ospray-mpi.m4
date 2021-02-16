dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`OSPRAY_MPI_VER',c42a885)

ifelse(OS_NAME,ubuntu,`
define(`OSPRAY_MPI_BUILD_DEPS',`ca-certificates g++ make ifdef(`BUILD_CMAKE',,cmake) git libglfw3-dev libgl1-mesa-dri libxrandr-dev  libxinerama-dev libxcursor-dev libmpich-dev mpich openssh-server openssh-client')
')

ifelse(OS_NAME,centos,`
define(`OSPRAY_MPI_BUILD_DEPS',`gcc-c++ make ifdef(`BUILD_CMAKE',,cmake) git glfw-devel mesa-dri-drivers libXrandr-devel libXinerama-devel libXcursor-devel mpich-devel openssh-server openssh-clients')
')

define(`BUILD_OSPRAY_MPI',
# build ospray mpi
ENV PATH=$PATH:/usr/lib64/mpich/bin

ARG OSPRAY_REPO=https://github.com/ospray/ospray.git
RUN cd BUILD_HOME && \
    git clone ${OSPRAY_REPO} ospray_mpi&& \
    mkdir ospray_mpi/build && \
    cd ospray_mpi/build && \
    git checkout OSPRAY_MPI_VER && \
    cmake -DOSPRAY_MODULE_MPI=ON -DOSPRAY_SG_OPENIMAGEIO=ON .. && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR

RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#Port/Port/g' /etc/ssh/sshd_config && \
    sed -i 's/^Port 22/Port 2222/g' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config && \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#   Port 22/Port 2222/g' /etc/ssh/ssh_config && \
    echo 'root:ospray' |chpasswd && \
    sed -i 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/g' /etc/ssh/ssh_config && \
    /usr/bin/ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
)

REG(OSPRAY_MPI)

include(end.m4)dnl
