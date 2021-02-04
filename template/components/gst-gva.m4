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
dnl
include(begin.m4)

DECLARE(`GVA_VER',v1.3)

DECLARE(`GVA_WITH_DRM',yes)
DECLARE(`GVA_WITH_X11',no)
DECLARE(`GVA_WITH_GLX',no)
DECLARE(`GVA_WITH_WAYLAND',no)
DECLARE(`GVA_WITH_EGL',no)

DECLARE(`GVA_ENABLE_PAHO_INST',OFF)
DECLARE(`GVA_ENABLE_RDKAFKA_INST',OFF)

include(dldt-ie.m4)
include(gst-plugins-base.m4)

ifdef(`ENABLE_INTEL_GFX_REPO',`dnl
pushdef(`GVA_INTEL_GFX_BUILD_DEPS',libva-dev)
pushdef(`GVA_INTEL_GFX_INSTALL_DEPS',`libva2 ifelse(GVA_WITH_DRM,yes,libva-drm2)')
',`dnl
pushdef(`GVA_INTEL_GFX_BUILD_DEPS',)
pushdef(`GVA_INTEL_GFX_INSTALL_DEPS',)
include(libva2.m4)
')

define(`GVA_BUILD_DEPS',cmake git ocl-icd-opencl-dev opencl-headers pkg-config GVA_INTEL_GFX_BUILD_DEPS)
define(`GVA_INSTALL_DEPS',GVA_INTEL_GFX_INSTALL_DEPS)

popdef(`GVA_INTEL_GFX_BUILD_DEPS')
popdef(`GVA_INTEL_GFX_INSTALL_DEPS')

define(`BUILD_GVA',
# formerly https://github.com/opencv/gst-video-analytics
ARG GVA_REPO=https://github.com/openvinotoolkit/dlstreamer_gst.git
RUN git clone $GVA_REPO BUILD_HOME/gst-video-analytics && \
    cd BUILD_HOME/gst-video-analytics && \
    git checkout GVA_VER && \
    git submodule update --init

# TODO: This is a workaround for a bug in dlstreamer_gst
ENV LIBRARY_PATH=BUILD_LIBDIR

RUN mkdir -p BUILD_HOME/gst-video-analytics/build \
    && cd BUILD_HOME/gst-video-analytics/build \
    && cmake \
        -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
        -DDISABLE_SAMPLES=ON \
        -DENABLE_PAHO_INSTALLATION=GVA_ENABLE_PAHO_INST \
        -DENABLE_RDKAFKA_INSTALLATION=GVA_ENABLE_RDKAFKA_INST \
        -DENABLE_VAAPI=ON \
        -DENABLE_VAS_TRACKER=OFF \
        -Dwith_drm=GVA_WITH_DRM \
        -Dwith_x11=GVA_WITH_X11 \
        -Dwith_glx=GVA_WITH_GLX \
        -Dwith_wayland=GVA_WITH_WAYLAND \
        -Dwith_egl=GVA_WITH_EGL \
        .. \
    && make -j $(nproc) \
    && make install \
    && make install DESTDIR=BUILD_DESTDIR
)

REG(GVA)

include(end.m4)
