include(envs.m4)
HIDE

DECLARE(`GSTCORE_VER',1.16.2)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTCORE_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison ')'
`define(`GSTCORE_INSTALL_DEPS',`libglib2.0-0 ')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTCORE_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex ')'
`define(`GSTCORE_INSTALL_DEPS',`glib2')'
)

define(`BUILD_GSTCORE',
ARG GSTCORE_REPO=https://github.com/GStreamer/gstreamer/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTCORE_REPO} | tar xz
RUN cd BUILD_HOME/gstreamer-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

define(`ENV_VARS_GSTCORE',
ENV GST_PLUGIN_PATH=BUILD_LIBDIR/gstreamer-1.0
ENV GST_PLUGIN_SCANNER=BUILD_LIBDIR/gstreamer-1.0/gst-plugin-scanner
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTCORE_BUILD_PROVIDES',`libgstreamer1.0-0')')

REG(GSTCORE)

UNHIDE