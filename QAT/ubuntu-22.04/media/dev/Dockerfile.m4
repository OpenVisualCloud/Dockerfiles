
include(begin.m4)
include(ubuntu.m4)
include(nasm.m4)
include(qat-core.m4)
include(qat-zip.m4)
include(openssl.m4)
include(qat-cryptomb.m4)
include(ipsecmb.m4)
include(qat-engine.m4)
include(nginx-flv.m4)
include(nginx-upload.m4)
include(qat-nginx.m4)
include(nginx-cert.m4)
include(end.m4)

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
define(`CLEANUP_CC',no)dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-OS_NAME`'patsubst(OS_VERSION,\.)-media-dev:BUILD_VERSION
LABEL Description="This is the QAT development image for OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(devel,build)
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1