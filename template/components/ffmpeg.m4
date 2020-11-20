include(envs.m4)
HIDE

DECLARE(`FFMPEG_VER',n4.2.2)
DECLARE(`FFMPEG_ENABLE_GPL',true)
DECLARE(`FFMPEG_ENABLE_LIBASS',true)
DECLARE(`FFMPEG_ENABLE_LIBFREETYPE',true)
DECLARE(`FFMPEG_ENABLE_X11',false)
DECLARE(`FFMPEG_ENABLE_NONFREE',true)

include(nasm.m4)
#include(openssl.m4)
#include(libvpx.m4)
#include(libopus.m4)
#include(libvorbis.m4)
#include(libfdk-aac.m4)
#include(libx264.m4)
#include(libx265.m4)
#include(libaom.m4)
#include(svt-av1.m4)
#include(svt-hevc.m4)

ifelse(OS_NAME,ubuntu,`
define(`FFMPEG_BUILD_DEPS',ca-certificates wget patch ifelse(FFMPEG_ENABLE_LIBASS,true,libass-dev )ifelse(FFMPEG_LIBFREETYPE,true,libfreetype6-dev ))
')

ifelse(OS_NAME,centos,`
define(`FFMPEG_BUILD_DEPS',wget patch ifelse(FFMPEG_ENABLE_LIBASS,true,libass-devel )ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,freetype-devel ))
')

define(`BUILD_FFMPEG',`
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/FFMPEG_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_REPO} | tar xz

ifdef(`BUILD_SVT_AV1',`FFMPEG_PATCH_SVT_AV1(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_SVT_HEVC',`FFMPEG_PATCH_SVT_HEVC(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl

RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared --disable-static --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages ifelse(FFMPEG_ENABLE_GPL,true,--enable-gpl )ifelse(FFMPEG_ENABLE_LIBASS,true,--enable-libass )ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,--enable-libfreetype )ifelse(FFMPEG_ENABLE_X11,false,--disable-xlib --disable-sdl2 )ifdef(`BUILD_OPENSSL',--enable-openssl --extra-ldflags=-Wl`,'-rpath=BUILD_PREFIX/ssl/lib )ifelse(FFMPEG_ENABLE_NONFREE,true,--enable-nonfree )ifdef(`BUILD_MSDK',--enable-libdrm --enable-libmfx ,--disable-vaapi --disable-hwaccels )ifdef(`BUILD_LIBFDKAAC',--enable-libfdk-aac )ifdef(`BUILD_LIBOPUS',--enable-libopus )ifdef(`BUILD_LIBVPX',--enable-libvpx ,--disable-libvpx )ifdef(`BUILD_LIBVORBIS',--enable-libvorbis )ifdef(`BUILD_LIBX264',--enable-libx264 )ifdef(`BUILD_LIBX265',--enable-libx265 )ifdef(`BUILD_SVT_AV1',--enable-libsvtav1 )ifdef(`BUILD_SVT_HEVC',--enable-libsvthevc )ifdef(`BUILD_LIBAOM',--enable-libaom ) && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

ifelse(OS_NAME,ubuntu,`
define(`FFMPEG_INSTALL_DEPS',ifelse(FFMPEG_ENABLE_LIBASS,true,libass9 )ifelse(FFMPEG_LIBFREETYPE,true,libfreetype6 ))
')

ifelse(OS_NAME,centos,`
define(`FFMPEG_INSTALL_DEPS',ifelse(FFMPEG_ENABLE_LIBASS,true,libass )ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,freetype )ifelse(OS_VERSION,7,glibc ))
')

define(`FFMPEG_BUILD_PROVIDES',ffmpeg)

REG(FFMPEG)

UNHIDE
