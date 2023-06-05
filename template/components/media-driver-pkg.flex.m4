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
define(`MEDIA_DRIVER_PKG_BUILD_DEPS',`ca-certificates gpg-agent software-properties-common wget')
define(`MEDIA_DRIVER_PKG_INSTALL_DEPS',`ca-certificates gpg-agent software-properties-common wget')
')

define(`INTEL_GFX_URL',https://repositories.intel.com/graphics)

define(`BUILD_MEDIA_DRIVER_PKG',`
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO - INTEL_GFX_URL/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu ifelse(OS_VERSION,20.04,focal,jammy) ifelse(OS_VERSION,20.04,main,arc)" | tee /etc/apt/sources.list.d/intel.gpu.ifelse(OS_VERSION,20.04,focal,jammy).list

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-opencl-icd libvpl2 intel-level-zero-gpu level-zero-dev intel-media-va-driver-non-free && \
  rm -rf /var/lib/apt/lists/*
')

define(`INSTALL_MEDIA_DRIVER_PKG',`
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO - INTEL_GFX_URL/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu ifelse(OS_VERSION,20.04,focal,jammy) ifelse(OS_VERSION,20.04,main,arc)" | tee /etc/apt/sources.list.d/intel.gpu.ifelse(OS_VERSION,20.04,focal,jammy).list

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-opencl-icd libvpl2 intel-level-zero-gpu level-zero-dev intel-media-va-driver-non-free && \
  rm -rf /var/lib/apt/lists/*
')

REG(MEDIA_DRIVER_PKG)

include(end.m4)dnl
