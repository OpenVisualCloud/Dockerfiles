
include(begin.m4)
include(centos-repo.m4)
include(cmake.m4)
include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libaom.m4)
include(dav1d.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
include(svt-vp9.m4)
include(gmmlib.sg1.m4)
include(libva2.sg1.m4)
include(media-driver.sg1.m4)
include(msdk.sg1.m4)
include(ffmpeg.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

INSTALL_CENTOS_REPO(epel-release centos-release-scl)

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the image for FFMPEG and Gstreamer application for media development on OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

INSTALL_CENTOS_REPO(epel-release)

# Install
INSTALL_ALL(devel,build)dnl

UPDATE_CENTOS_REPO()
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1