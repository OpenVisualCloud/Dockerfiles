dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2023, Intel Corporation
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

ifelse(OS_NAME,ubuntu,`

define(`OPENCL_BUILD_DEPS',`ca-certificates wget')
define(`BUILD_OPENCL',`
# build opencl
ARG OPENCL_GMMLIB_REPO=https://github.com/intel/compute-runtime/releases/download/22.30.23789/libigdgmm12_22.1.3_amd64.deb
ARG OPENCL_IGC_CORE_REPO=https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.11485/intel-igc-core_1.0.11485_amd64.deb
ARG OPENCL_IGC_OCL_REPO=https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.11485/intel-igc-opencl_1.0.11485_amd64.deb
ARG OPENCL_INTEL_OCL_REPO=https://github.com/intel/compute-runtime/releases/download/22.30.23789/intel-opencl-icd_22.30.23789_amd64.deb

RUN mkdir -p BUILD_HOME/opencl && \
    cd BUILD_HOME/opencl && \
    wget ${OPENCL_GMMLIB_REPO} ${OPENCL_IGC_CORE_REPO} ${OPENCL_IGC_OCL_REPO} ${OPENCL_INTEL_OCL_REPO} && \
    dpkg -i ./*.deb && \
    for x in *.deb; do dpkg-deb -x $x defn(`BUILD_DESTDIR',`BUILD_PREFIX'); done
')

')

ifelse(OS_NAME,centos,`

define(`OPENCL_BUILD_DEPS',`yum-plugin-copr')
define(`BUILD_OPENCL',`
# build opencl
RUN yum copr enable -y jdanecki/intel-opencl
RUN yum install -y intel-opencl ocl-icd libgomp
RUN ln -s /usr/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so
')

')

REG(OPENCL)

include(end.m4)dnl
