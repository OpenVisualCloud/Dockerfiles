include(envs.m4)
include(ubuntu.m4)
HIDE

define(`INTEL_GFX_URL',https://repositories.intel.com/graphics)

pushdef(`_install_ubuntu',`dnl
pushdef(`_tmp',`ifelse($1,`',UBUNTU_CODENAME(OS_VERSION),UBUNTU_CODENAME(OS_VERSION)-$1)')dnl
INSTALL_PKGS(PKGS(curl ca-certificates gpg-agent software-properties-common))

RUN curl -fsSL INTEL_GFX_URL/intel-graphics.key | apt-key add -
RUN apt-add-repository "deb INTEL_GFX_URL/ubuntu _tmp main"
popdef(`_tmp')')

ifelse(OS_NAME,ubuntu,ifelse(OS_VERSION,20.04,
`define(`ENABLE_INTEL_GFX_REPO',defn(`_install_ubuntu'))'))

popdef(`_install_ubuntu')

ifdef(`ENABLE_INTEL_GFX_REPO',,dnl
  `ERROR(`Intel Graphics Repositories don't support OS_NAME:OS_VERSION')')
UNHIDE
