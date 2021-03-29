dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`FFMPEG_VER',n4.2.4)
DECLARE(`FFMPEG_ENABLE_GPL',true)
DECLARE(`FFMPEG_ENABLE_LIBASS',true)
DECLARE(`FFMPEG_ENABLE_LIBFREETYPE',true)
DECLARE(`FFMPEG_ENABLE_X11',false)
DECLARE(`FFMPEG_ENABLE_NONFREE',true)
DECLARE(`FFMPEG_ENABLE_V4L2',true)
DECLARE(`FFMPEG_ENABLE_HWACCELS',ifdef(`ENABLE_INTEL_GFX_REPO',true,ifdef(`BUILD_LIBVA2',true,false)))
DECLARE(`FFMPEG_ENABLE_LIBMFX',ifdef(`BUILD_MSDK',FFMPEG_ENABLE_HWACCELS,false))
DECLARE(`FFMPEG_ENABLE_VAAPI',ifdef(`BUILD_LIBVA2',FFMPEG_ENABLE_HWACCELS,false))
DECLARE(`FFMPEG_ENABLE_X265',true)
DECLARE(`FFMPEG_ENABLE_X264',true)
DECLARE(`FFMPEG_FLV_PATCH',true)
DECLARE(`FFMPEG_WARNING_AS_ERRORS',false)

include(nasm.m4)

dnl Optional flags can set ON or OFF different plugins inside this ffmpeg component.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D FFMPEG_*=false` value.
dnl For more information about optional configurations for this ffmpeg component go to:
dnl https://github.com/FFmpeg/FFmpeg/blob/master/configure

ifelse(OS_NAME,ubuntu,`
define(`FFMPEG_BUILD_DEPS',`build-essential ca-certificates wget patch ifdef(`BUILD_LIBX264',,ifelse(FFMPEG_ENABLE_X264,true,libx264-dev)) ifdef(`BUILD_LIBX265',,ifelse(FFMPEG_ENABLE_X265,true,libx265-dev)) ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-dev) ifelse(FFMPEG_ENABLE_LIBASS,true,libass-dev) ifelse(FFMPEG_LIBFREETYPE,true,libfreetype6-dev) ifdef(`ENABLE_INTEL_GFX_REPO',libva-dev)')

define(`FFMPEG_INSTALL_DEPS',`libxcb-shape0 libxcb-xfixes0 ifdef(`BUILD_LIBX264',,ifelse(FFMPEG_ENABLE_X264,true,lib264-ifelse(OS_VERSION,18.04,152,155))) ifdef(`BUILD_LIBX265',,ifelse(FFMPEG_ENABLE_X265,true,libx265-ifelse(OS_VERSION,146,179))) ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-0) ifelse(FFMPEG_ENABLE_LIBASS,true,libass9) ifdef(`ENABLE_INTEL_GFX_REPO',libva2)')
')

ifelse(OS_NAME,centos,`
define(`FFMPEG_BUILD_DEPS',`wget patch ifdef(`BUILD_LIBX264',,ifelse(FFMPEG_ENABLE_X264,true,libx264-devel)) ifdef(`BUILD_LIBX265',,ifelse(FFMPEG_ENABLE_X265,true,x265-devel)) ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-devel) ifelse(FFMPEG_ENABLE_LIBASS,true,libass-devel) ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,freetype-devel)')
define(`FFMPEG_INSTALL_DEPS',`ifdef(`BUILD_LIBX264',,ifelse(FFMPEG_ENABLE_X264,true,libx264-static)) ifdef(`BUILD_LIBX265',,ifelse(FFMPEG_ENABLE_X265,true,x265)) ifelse(FFMPEG_ENABLE_V4L2,true,libv4l) ifelse(FFMPEG_ENABLE_LIBASS,true,libass)')
')

define(`BUILD_FFMPEG',`
# build ffmpeg
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/FFMPEG_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_REPO} | tar xz

ifdef(`BUILD_SVT_AV1',`FFMPEG_PATCH_SVT_AV1(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_SVT_HEVC',`FFMPEG_PATCH_SVT_HEVC(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_SVT_VP9',`FFMPEG_PATCH_SVT_VP9(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_DLDT',`FFMPEG_PATCH_ANALYTICS(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_OPENVINO',`FFMPEG_PATCH_ANALYTICS(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_LIBVA2',`FFMPEG_PATCH_VAAPI(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl

ifdef(`FFMPEG_FLV_PATCH',
ARG FFMPEG_PATCHES_RELEASE_VER=0.2
ARG FFMPEG_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${FFMPEG_PATCHES_RELEASE_VER}.tar.gz
ARG FFMPEG_PATCHES_PATH=BUILD_HOME/CDN-${FFMPEG_PATCHES_RELEASE_VER}

RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_PATCHES_RELEASE_URL} | tar xz && \
    cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
    find ${FFMPEG_PATCHES_PATH}/FFmpeg_patches -type f -name *.patch -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;
)dnl

RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared --disable-static --disable-doc --disable-htmlpages \
    --disable-manpages --disable-podpages --disable-txtpages \
    ifelse(FFMPEG_WARNING_AS_ERRORS,false,--extra-cflags=-w )dnl
    ifelse(FFMPEG_ENABLE_GPL,true,--enable-gpl )dnl
    ifelse(FFMPEG_ENABLE_NONFREE,true,--enable-nonfree )dnl
    ifelse(FFMPEG_ENABLE_LIBASS,true,--enable-libass )dnl
    ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,--enable-libfreetype )dnl
    ifelse(FFMPEG_ENABLE_X11,false,--disable-xlib --disable-sdl2 )dnl
    ifelse(FFMPEG_ENABLE_HWACCELS,true,,--disable-hwaccels )dnl
    ifelse(FFMPEG_ENABLE_LIBMFX,true,--enable-libmfx )dnl
    ifelse(FFMPEG_ENABLE_VAAPI,true,--enable-vaapi ,--disable-vaapi )dnl
    ifelse(FFMPEG_ENABLE_V4L2,true,--enable-libv4l2 --enable-indev=v4l2 )dnl
    ifdef(`BUILD_OPENSSL',--enable-openssl --extra-ldflags=-Wl`,'-rpath=BUILD_PREFIX/ssl/lib )dnl
    ifdef(`BUILD_LIBFDKAAC',--enable-libfdk-aac )dnl
    ifdef(`BUILD_LIBOPUS',--enable-libopus )dnl
    ifdef(`BUILD_LIBVPX',--enable-libvpx ,--disable-libvpx )dnl
    ifdef(`BUILD_LIBVORBIS',--enable-libvorbis )dnl
    ifelse(FFMPEG_ENABLE_X264,true,--enable-libx264 )dnl
    ifelse(FFMPEG_ENABLE_X265,true,--enable-libx265 )dnl
    ifdef(`BUILD_SVT_AV1',--enable-libsvtav1 )dnl
    ifdef(`BUILD_SVT_HEVC',--enable-libsvthevc )dnl
    ifdef(`BUILD_SVT_VP9',--enable-libsvtvp9 )dnl
    ifdef(`BUILD_LIBAOM',--enable-libaom )dnl
    ifdef(`BUILD_DAV1D',--enable-libdav1d )dnl
    ifdef(`BUILD_LIBRDKAFKA',--enable-librdkafka )dnl
    ifdef(`BUILD_LIBJSONC',--enable-libjson_c )dnl
    ifdef(`BUILD_DLDT',--enable-libinference_engine_c_api --extra-cflags=-I$CUSTOM_IE_DIR/include --extra-ldflags=-L$CUSTOM_IE_LIBDIR )dnl
    ifdef(`BUILD_OPENVINO',--enable-libinference_engine_c_api --extra-cflags=-I$OPENVINO_IE_DIR/include --extra-ldflags=-L$OPENVINO_IE_DIR/lib/intel64 )dnl
    && make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
ifdef(`REBUILD_OPENCV_VIDEOIO',`dnl
REBUILD_OPENCV_VIDEOIO()dnl
')dnl
')

REG(FFMPEG)

include(end.m4)dnl
