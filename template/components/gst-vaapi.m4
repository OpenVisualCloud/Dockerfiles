include(envs.m4)
include(libva2-utils.m4)
include(msdk.m4)
include(media-driver.m4)
include(gst-plugins-bad.m4)
HIDE

dnl Optional libraries can set ON or OFF different plugins inside this vaapi gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this vaapi gst plugin go to:
dnl https://github.com/GStreamer/gstreamer-vaapi/blob/master/README
DECLARE(`GST_X264ENC',true)
DECLARE(`GST_X265',true)
DECLARE(`GST_VPX',true)

define(`GST_X264ENC_BUILD',dnl
ifelse(GST_X264ENC,true,`ifdef(`BUILD_LIBX264',,ifelse(
OS_NAME,ubuntu,libx264-dev,
OS_NAME,centos,libx264-devel))'))dnl

define(`GST_X264ENC_INSTALL',dnl
ifelse(GST_X264ENC,true,`ifdef(`BUILD_LIBX264',,ifelse(
OS_NAME,ubuntu,libx264-155,
OS_NAME,centos,libx264-static))'))dnl

define(`GST_X265_BUILD',dnl
ifelse(GST_X265,true,`ifdef(`BUILD_LIBX265',,ifelse(
OS_NAME,ubuntu,libx265-dev,
OS_NAME,centos,x265-devel))'))dnl

define(`GST_X265_INSTALL',dnl
ifelse(GST_X265,true,`ifdef(`BUILD_LIBX265',,ifelse(
OS_NAME,ubuntu,libx265-179,
OS_NAME,centos,x265))'))dnl

define(`GST_VPX_BUILD',dnl
ifelse(GST_VPX,true,`ifdef(`BUILD_LIBVPX',,ifelse(
OS_NAME,ubuntu,libvpx-dev,
OS_NAME,centos,libvpx-devel))'))dnl

define(`GST_VPX_INSTALL',dnl
ifelse(GST_VPX,true,`ifdef(`BUILD_LIBVPX',,ifelse(
OS_NAME,ubuntu,libvpx6,
OS_NAME,centos,libvpx))'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTVAAPI_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison libglu1-mesa-dev GST_X264ENC_BUILD GST_X265_BUILD GST_VPX_BUILD')'
`define(`GSTVAAPI_INSTALL_DEPS',`libglib2.0-0 libpciaccess0 libglu1-mesa GST_X264ENC_INSTALL GST_X265_INSTALL GST_VPX_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTVAAPI_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex mesa-libGLU-devel GST_X264ENC_BUILD GST_X265_BUILD GST_VPX_BUILD')'
`define(`GSTVAAPI_INSTALL_DEPS',`glib2 libpciaccess mesa-libGLU GST_X264ENC_INSTALL GST_X265_INSTALL GST_VPX_INSTALL')'
)

define(`BUILD_GSTVAAPI',
ARG GSTVAAPI_REPO=https://github.com/GStreamer/gstreamer-vaapi/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTVAAPI_REPO} | tar xz
RUN cd BUILD_HOME/gstreamer-vaapi-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTVAAPI_BUILD_PROVIDES',`gstreamer1.0-vaapi')')

define(`ENV_VARS_GSTVAAPI',
ENV GST_VAAPI_ALL_DRIVERS=1
ENV DISPLAY=:0.0
)

REG(GSTVAAPI)

UNHIDE