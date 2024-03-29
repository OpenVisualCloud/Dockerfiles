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

DECLARE(`GVA_VER',master)
DECLARE(`GVA_VER_HASH',ec2748da5b577bbf510525f57eabde6c58efd589)

DECLARE(`GVA_WITH_DRM',no)
DECLARE(`GVA_WITH_X11',no)
DECLARE(`GVA_WITH_GLX',no)
DECLARE(`GVA_WITH_WAYLAND',no)
DECLARE(`GVA_WITH_EGL',no)

DECLARE(`GVA_ENABLE_PAHO_INST',ifdef(`BUILD_LIBPAHO',ON,OFF))
DECLARE(`GVA_ENABLE_RDKAFKA_INST',ifdef(`BUILD_LIBRDKAFKA',ON,OFF))
DECLARE(`GVA_ENABLE_AUDIO_INFERENCE_ELEMENTS',ON)
DECLARE(`GVA_ENABLE_VAAPI',ifdef(`BUILD_MEDIA_DRIVER_PKG',ON,OFF))
DECLARE(`GVA_ENABLE_WARNING_AS_ERRORS',OFF)
include(gst-plugins-base.m4)

ifelse(OS_NAME,ubuntu,`
define(`GVA_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake) git ocl-icd-opencl-dev opencl-headers pkg-config libpython3-dev python-gi-dev ca-certificates ifdef(`BUILD_LIBVA2',,libva-dev) curl gnupg2 software-properties-common')
define(`GVA_INSTALL_DEPS',`ocl-icd-libopencl1 python3-gi python3-gi-cairo python3-dev libgl1-mesa-glx ifdef(`ENABLE_INTEL_GFX_REPO',libva2 ifelse(GVA_WITH_DRM,yes,libva-drm2))')
')

ifelse(OS_NAME,centos,`
define(`GVA_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake3) git ocl-icd-devel opencl-headers pkg-config ca-certificates python36-gobject-devel python3-devel')
define(`GVA_INSTALL_DEPS',`ocl-icd libass python3-devel boost-regex python36-gobject python36-gobject-devel python36-gobject-base')
')

define(`BUILD_GVA',`
# build gst-plugin-gva
# formerly https://github.com/opencv/gst-video-analytics
ARG GVA_REPO=https://github.com/dlstreamer/dlstreamer
ENV LIBRARY_PATH=BUILD_LIBDIR
RUN git clone -b GVA_VER $GVA_REPO BUILD_HOME/gst-video-analytics && \
    cd BUILD_HOME/gst-video-analytics && \
    git checkout GVA_VER_HASH && \
    git submodule update --init && \
    mkdir -p build && cd build && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) \
    -DVERSION_PATCH="$(git rev-list --count --first-parent HEAD)" \
    -DGIT_INFO=git_"$(git rev-parse --short HEAD)" \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_PAHO_INSTALLATION=GVA_ENABLE_PAHO_INST \
    -DENABLE_RDKAFKA_INSTALLATION=GVA_ENABLE_RDKAFKA_INST \
    -DENABLE_VAAPI=GVA_ENABLE_VAAPI \
    -DENABLE_AUDIO_INFERENCE_ELEMENTS=GVA_ENABLE_AUDIO_INFERENCE_ELEMENTS \
    -DTREAT_WARNING_AS_ERROR=GVA_ENABLE_WARNING_AS_ERRORS \
    .. \
    && make -j "$(nproc)" \
    && make install \
    && make install DESTDIR=BUILD_DESTDIR ifelse(OS_NAME:OS_VERSION,centos:7,` )')

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:BUILD_LIBDIR/gstreamer-1.0/:/usr/local/lib/

RUN cp -r  BUILD_HOME/gst-video-analytics/build/intel64/Release/lib/* BUILD_LIBDIR/gstreamer-1.0/.
RUN cp -r  BUILD_HOME/gst-video-analytics/build/intel64/Release/lib/* BUILD_DESTDIR/BUILD_LIBDIR/gstreamer-1.0/.
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:BUILD_LIBDIR/gstreamer-1.0/

RUN mkdir -p /opt/intel/dl_streamer/python && \
    cp -r BUILD_HOME/gst-video-analytics/python/* /opt/intel/dl_streamer/python

ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
RUN mkdir -p BUILD_DESTDIR/opt/intel/dl_streamer/python && \
    cp -r BUILD_HOME/gst-video-analytics/python/* BUILD_DESTDIR/opt/intel/dl_streamer/python
')

define(`INSTALL_GVA',
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:BUILD_LIBDIR/gstreamer-1.0/
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:BUILD_LIBDIR/girepository-1.0/ 
ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:BUILD_LIBDIR/gstreamer-1.0/
)

REG(GVA)

include(end.m4)
