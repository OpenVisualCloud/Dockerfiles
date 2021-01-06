include(envs.m4)
include(gst-plugins-base.m4)
HIDE

dnl Optional libraries can set ON or OFF different plugins inside this ugly gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this ugly gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-ugly/blob/master/REQUIREMENTS
DECLARE(`GST_X264ENC',true)

define(`GST_X264ENC_BUILD',dnl
ifelse(GST_X264ENC,true,`ifelse(
OS_NAME,ubuntu,libx264-dev,
OS_NAME,centos,libx264-devel)'))dnl

define(`GST_X264ENC_INSTALL',dnl
ifelse(GST_X264ENC,true,`ifelse(
OS_NAME,ubuntu,libx264-155,
OS_NAME,centos,libx264-static)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTUGLY_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_X264ENC_BUILD')'
`define(`GSTUGLY_INSTALL_DEPS',`libglib2.0-0 GST_X264ENC_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTUGLY_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_X264ENC_BUILD')'
`define(`GSTUGLY_INSTALL_DEPS',`glib2 GST_X264ENC_INSTALL')'
)

define(`BUILD_GSTUGLY',
ARG GSTUGLY_REPO=https://github.com/GStreamer/gst-plugins-ugly/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTUGLY_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-ugly-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTUGLY_BUILD_PROVIDES',`gstreamer1.0-plugins-ugly')')

REG(GSTUGLY)

UNHIDE