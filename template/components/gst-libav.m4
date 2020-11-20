include(envs.m4)
include(ffmpeg.m4)
include(gst-plugins-base.m4)
HIDE

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTLIBAV_BUILD_DEPS',`ca-certificates tar g++ wget meson')'
`define(`GSTLIBAV_INSTALL_DEPS',`')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTLIBAV_BUILD_DEPS',` wget tar gcc-c++ meson')'
`define(`GSTLIBAV_INSTALL_DEPS',`')'
)

define(`BUILD_GSTLIBAV',
ARG GSTLIBAV_REPO=https://github.com/GStreamer/gst-libav/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTLIBAV_REPO} | tar xz
RUN cd BUILD_HOME/gst-libav-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

REG(GSTLIBAV)

UNHIDE
