include(begin.m4)

include(gst-plugins-base.m4)

ifelse(OS_NAME,ubuntu,`
define(`GSTSVT_BUILD_DEPS',`ca-certificates tar g++ wget ifdef(`BUILD_MESON',,meson)')
')

ifelse(OS_NAME,centos,`
define(`GSTSVT_BUILD_DEPS',`wget tar gcc-c++ ifdef(`BUILD_MESON',,meson)')
')

define(`BUILD_GSTSVT',`
# build gst-plugin-svt
ifdef(`BUILD_SVT_HEVC',`dnl
RUN cd BUILD_HOME/SVT-HEVC/gstreamer-plugin && \
    meson build -Dprefix=BUILD_PREFIX --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
')dnl
ifdef(`BUILD_SVT_AV1',`dnl
RUN cd BUILD_HOME/SVT-AV1/gstreamer-plugin && \
    meson build -Dprefix=BUILD_PREFIX --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
')dnl
')

REG(GSTSVT)

include(end.m4)
