include(begin.m4)

include(svt-hevc.m4)
include(svt-av1.m4)
include(gst-plugins-base.m4)

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTSVT_BUILD_DEPS',`ca-certificates tar g++ wget meson')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTSVT_BUILD_DEPS',`wget tar gcc-c++ meson')'
)

define(`BUILD_GSTSVT',`
ifdef(`BUILD_SVT_HEVC',RUN \
    cd BUILD_HOME/SVT-HEVC/gstreamer-plugin && \
    meson build -Dprefix=BUILD_PREFIX --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install)

ifdef(`BUILD_SVT_AV1',RUN \
    cd BUILD_HOME/SVT-AV1/gstreamer-plugin && \
    meson build -Dprefix=BUILD_PREFIX --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install)
')

REG(GSTSVT)

include(end.m4)
