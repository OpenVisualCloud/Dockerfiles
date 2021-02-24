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

include(gst-gva.m4)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTPYTHON_BUILD_DEPS',`ca-certificates tar g++ wget gtk-doc-tools uuid-dev python-gi-dev python3-dev libtool-bin libpython3-dev libpython3-stdlib libpython3-all-dev ')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTPYTHON_BUILD_DEPS',`wget tar gcc-c++ glib2-devel gtk-dock openblas python3 python36-gobject-devel python3-devel ifdef(`BUILD_MESON',,meson)')'
)

define(`BUILD_GSTPYTHON',
ARG GSTPYTHON_REPO=https://gstreamer.freedesktop.org/src/gst-python/gst-python-GSTCORE_VER.tar.xz
RUN cd BUILD_HOME && \
    wget -O - ${GSTPYTHON_REPO} | tar xJ
RUN cd BUILD_HOME/gst-python-GSTCORE_VER && \
#WORKAROUND: https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/30/diffs
ifelse(OS_VERSION,20.04,
    sed -i "s/.*python\.dependency.*/pythonver \= python\.language_version\(\)\npython_dep \= dependency\(\'python-\@0\@-embed\'\.format\(pythonver\)\, version\: \'\>\=3\'\, required\: false\)\nif not python_dep\.found\(\)\n\tpython_dep \= python\.dependency\(required \: true\)\nendif/g" meson.build && \)
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dpython=/usr/bin/python3 -Dlibpython-dir=/usr/lib/x86_64-linux-gnu/ \
    -Dpygi-overrides-dir=/usr/lib/python3/dist-packages/gi/overrides \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install

)

REG(GSTPYTHON)

include(end.m4)dnl
