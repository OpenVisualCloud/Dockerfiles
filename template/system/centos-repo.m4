dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2020, Intel Corporation
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

define(`ENABLE_CENTOS_REPO',`dnl
RUN sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/CentOS-$1.repo
')

define(`INSTALL_CENTOS_REPO',`dnl
RUN yum install -y -q $1
')

define(`INSTALL_CENTOS_RPMFUSION_REPO',
RUN dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$1.noarch.rpm && \
    dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$1.noarch.rpm)

define(`INSTALL_CENTOS_OKEY_REPO',
RUN dnf install -y http://repo.okay.com.mx/centos/$1/x86_64/release/okay-release-1-2.el$1.noarch.rpm)

define(`INSTALL_CENTOS_RAVEN_RELEASE_REPO',
RUN dnf install -y https://pkgs.dyn.su/el$1/base/x86_64/raven-release-1.0-1.el$1.noarch.rpm
RUN sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/raven.repo)dnl
