include(envs.m4)
include(gst-plugins-base.m4)
HIDE

dnl Optional libraries can set ON or OFF different plugins inside this bad gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this bad gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-bad/blob/master/REQUIREMENTS
DECLARE(`GST_CURLUSESSL',true)
DECLARE(`GST_RTMP',true)
DECLARE(`GST_MJPEG',true)

define(`GST_CURLUSESSL_BUILD',dnl
ifelse(GST_CURLUSESSL,true,`ifelse(
OS_NAME,ubuntu,libssl-dev,
OS_NAME,centos,openssl-devel)'))dnl

define(`GST_CURLUSESSL_INSTALL',dnl
ifelse(GST_CURLUSESSL,true,`ifelse(
OS_NAME,ubuntu,,dnl no required runtime dependency
OS_NAME,centos,dnl no required runtime dependency
)'))dnl

define(`GST_RTMP_BUILD',dnl
ifelse(GST_RTMP,true,`ifelse(
OS_NAME,ubuntu,librtmp-dev,
OS_NAME,centos,librtmp-devel)'))dnl

define(`GST_RTMP_INSTALL',dnl
ifelse(GST_RTMP,true,`ifelse(
OS_NAME,ubuntu,librtmp1,
OS_NAME,centos,librtmp)'))dnl

define(`GST_MJPEG_BUILD',dnl
ifelse(GST_MJPEG,true,`ifelse(
OS_NAME,ubuntu,mjpegtools,
OS_NAME,centos,mjpegtools)'))dnl

define(`GST_MJPEG_INSTALL',dnl
ifelse(GST_MJPEG,true,`ifelse(
OS_NAME,ubuntu,mjpegtools,
OS_NAME,centos,mjpegtools)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBAD_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_CURLUSESSL_BUILD GST_RTMP_BUILD GST_MJPEG_BUILD')'
`define(`GSTBAD_INSTALL_DEPS',`libglib2.0-0 GST_CURLUSESSL_INSTALL GST_RTMP_INSTALL GST_MJPEG_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTBAD_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_CURLUSESSL_BUILD GST_RTMP_BUILD GST_MJPEG_BUILD')'
`define(`GSTBAD_INSTALL_DEPS',`glib2 GST_CURLUSESSL_INSTALL GST_RTMP_INSTALL GST_MJPEG_INSTALL')'
)

define(`BUILD_GSTBAD',
ARG GSTBAD_REPO=https://github.com/GStreamer/gst-plugins-bad/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTBAD_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-bad-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBAD_BUILD_PROVIDES',`gstreamer1.0-plugins-bad')')

REG(GSTBAD)

UNHIDE