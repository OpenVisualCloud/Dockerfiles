include(envs.m4)
include(gst-core.m4)
HIDE

dnl Optional libraries can set ON or OFF different plugins inside this base gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this base gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-base/blob/master/REQUIREMENTS
DECLARE(`GST_XLIB',true)
DECLARE(`GST_ALSA',true)
DECLARE(`GST_PANGO',true)
DECLARE(`GST_THEORA',true)
DECLARE(`GST_LIBVISUAL',true)
DECLARE(`GST_OPENGL',true)

define(`GST_XLIB_BUILD',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-dev libxv-dev libxt-dev,
OS_NAME,centos,libX11-devel libXv-devel libXt-devel)'))dnl

define(`GST_XLIB_INSTALL',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-6 libxv1 libxt6,
OS_NAME,centos,libX11 libXv libXt)'))dnl

define(`GST_ALSA_BUILD',dnl
ifelse(GST_ALSA,true,`ifelse(
OS_NAME,ubuntu,libasound2-dev,
OS_NAME,centos,alsa-lib-devel)'))dnl

define(`GST_ALSA_INSTALL',dnl
ifelse(GST_ALSA,true,`ifelse(
OS_NAME,ubuntu,libasound2,
OS_NAME,centos,alsa-lib)'))dnl

define(`GST_PANGO_BUILD',dnl
ifelse(GST_PANGO,true,`ifelse(
OS_NAME,ubuntu,libpango1.0-dev,
OS_NAME,centos,pango-devel)'))dnl

define(`GST_PANGO_INSTALL',dnl
ifelse(GST_PANGO,true,`ifelse(
OS_NAME,ubuntu,libpango-1.0-0,
OS_NAME,centos,pango)'))dnl

define(`GST_THEORA_BUILD',dnl
ifelse(GST_THEORA,true,`ifelse(
OS_NAME,ubuntu,libtheora-dev,
OS_NAME,centos,libtheora)'))dnl

define(`GST_THEORA_INSTALL',dnl
ifelse(GST_THEORA,true,`ifelse(
OS_NAME,ubuntu,libtheora0,
OS_NAME,centos,libtheora)'))dnl

define(`GST_LIBVISUAL_BUILD',dnl
ifelse(GST_LIBVISUAL,true,`ifelse(
OS_NAME,ubuntu,libvisual-0.4-dev,
OS_NAME,centos,libvisual)'))dnl

define(`GST_LIBVISUAL_INSTALL',dnl
ifelse(GST_LIBVISUAL,true,`ifelse(
OS_NAME,ubuntu,libvisual-0.4-0,
OS_NAME,centos,libvisual)'))dnl

define(`GST_OPENGL_BUILD',dnl
ifelse(GST_OPENGL,true,`ifelse(
OS_NAME,ubuntu,libgl1-mesa-dev,
OS_NAME,centos,mesa-libGL-devel)'))dnl

define(`GST_OPENGL_INSTALL',dnl
ifelse(GST_OPENGL,true,`ifelse(
OS_NAME,ubuntu,libegl1-mesa,
OS_NAME,centos,mesa-libGL)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBASE_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_XLIB_BUILD GST_ALSA_BUILD GST_PANGO_BUILD GST_THEORA_BUILD GST_LIBVISUAL_BUILD GST_OPENGL_BUILD')'
`define(`GSTBASE_INSTALL_DEPS',`libglib2.0-0 GST_XLIB_INSTALL GST_ALSA_INSTALL GST_PANGO_INSTALL GST_THEORA_INSTALL GST_LIBVISUAL_INSTALL GST_OPENGL_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTBASE_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_XLIB_BUILD GST_ALSA_BUILD GST_PANGO_BUILD GST_THEORA_BUILD GST_LIBVISUAL_BUILD GST_OPENGL_BUILD')'
`define(`GSTBASE_INSTALL_DEPS',`glib2 GST_XLIB_INSTALL GST_ALSA_INSTALL GST_PANGO_INSTALL GST_THEORA_INSTALL GST_LIBVISUAL_INSTALL GST_OPENGL_INSTALL')'
)

define(`BUILD_GSTBASE',
ARG GSTBASE_REPO=https://github.com/GStreamer/gst-plugins-base/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTBASE_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-base-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBASE_BUILD_PROVIDES',`gstreamer1.0-plugins-base')')

REG(GSTBASE)

UNHIDE