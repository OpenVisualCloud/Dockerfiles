dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2022, Intel Corporation
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

DECLARE(`FFMPEG_VER',n4.4.3)
DECLARE(`FFMPEG_SHA',f6a36c7)
DECLARE(`FFMPEG_ENABLE_LIBASS',true)
DECLARE(`FFMPEG_ENABLE_LIBFREETYPE',true)
DECLARE(`FFMPEG_ENABLE_X11',false)
DECLARE(`FFMPEG_ENABLE_NONFREE',ifdef(`BUILD_LIBFDKAAC',true,false))
DECLARE(`FFMPEG_ENABLE_V4L2',true)
DECLARE(`FFMPEG_ENABLE_HWACCELS',ifdef(`ENABLE_INTEL_GFX_REPO',true,ifdef(`BUILD_LIBVA2',true,false)))
DECLARE(`FFMPEG_ENABLE_LIBMFX',ifdef(`BUILD_MSDK',FFMPEG_ENABLE_HWACCELS,false))
DECLARE(`FFMPEG_ENABLE_VAAPI',ifdef(`BUILD_LIBVA2',FFMPEG_ENABLE_HWACCELS,false))
DECLARE(`FFMPEG_FLV_PATCH',false)
DECLARE(`FFMPEG_1TN_PATCH',true)
DECLARE(`FFMPEG_WARNING_AS_ERRORS',false)

include(nasm.m4)

dnl Optional flags can set ON or OFF different plugins inside this ffmpeg component.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D FFMPEG_*=false` value.
dnl For more information about optional configurations for this ffmpeg component go to:
dnl https://github.com/FFmpeg/FFmpeg/blob/master/configure

ifelse(OS_NAME,ubuntu,`
define(`FFMPEG_BUILD_DEPS',`build-essential ca-certificates wget patch git ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-dev) ifelse(FFMPEG_ENABLE_LIBASS,true,libass-dev) ifelse(FFMPEG_LIBFREETYPE,true,libfreetype6-dev) ifdef(`ENABLE_INTEL_GFX_REPO',libva-dev)')

define(`FFMPEG_INSTALL_DEPS',`libxcb-shape0 libxcb-xfixes0 ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-0) ifelse(FFMPEG_ENABLE_LIBASS,true,libass9) ifdef(`ENABLE_INTEL_GFX_REPO',libva2)')
')

ifelse(OS_NAME,centos,`
define(`FFMPEG_BUILD_DEPS',`wget patch git ifelse(FFMPEG_ENABLE_V4L2,true,libv4l-devel) ifelse(FFMPEG_ENABLE_LIBASS,true,libass-devel) ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,freetype-devel)')
define(`FFMPEG_INSTALL_DEPS',`ifelse(FFMPEG_ENABLE_V4L2,true,libv4l) ifelse(FFMPEG_ENABLE_LIBASS,true,libass)')
')

define(`BUILD_FFMPEG',`
# build ffmpeg
#ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/FFMPEG_VER.tar.gz
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg
RUN cd BUILD_HOME && \
    git clone ${FFMPEG_REPO} && \
    cd FFmpeg && \
    git checkout ifelse(index(IMAGE,`owt'),-1,`FFMPEG_SHA',`FFMPEG_VER')

#ifdef(`BUILD_SVT_HEVC',`FFMPEG_PATCH_SVT_HEVC(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
#ifdef(`BUILD_SVT_HEVC',`FFMPEG_PATCH_SVT_HEVC(BUILD_HOME/FFmpeg)')dnl
#ifdef(`BUILD_LIBVA2',`FFMPEG_PATCH_VAAPI(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
ifdef(`BUILD_LIBVA2',`FFMPEG_PATCH_VAAPI(BUILD_HOME/FFmpeg)')dnl
ifdef(`BUILD_ONEVPL_DISP',`
include(media-delivery.m4)

RUN cd BUILD_HOME/FFmpeg && \
    cp BUILD_HOME/media-delivery/patches/ffmpeg/* . && \
    { set -e; \
    for patch_file in $(find -iname "*.patch" | sort -n); do \
    echo "Applying: ${patch_file}"; \
    patch -p1 < ${patch_file}; \
    done; }
')dnl


ifelse(index(IMAGE,`owt'),-1,ifelse(FFMPEG_1TN_PATCH,true,
ARG FFMPEG_1TN_PATCH_REPO=https://github.com/spawlows/FFmpeg/commit/6e747101f5fc0c4fb56a178c8ba24fcee4917139.patch
#RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
RUN cd BUILD_HOME/FFmpeg && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1;, 
))dnl


#RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
RUN cd BUILD_HOME/FFmpeg && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared --disable-static --disable-doc --disable-htmlpages \
    --disable-manpages --disable-podpages --disable-txtpages \
    ifelse(FFMPEG_WARNING_AS_ERRORS,false,--extra-cflags=-w )dnl
    ifelse(FFMPEG_ENABLE_NONFREE,true,--enable-nonfree )dnl
    ifelse(FFMPEG_ENABLE_LIBASS,true,--enable-libass )dnl
    ifelse(FFMPEG_ENABLE_LIBFREETYPE,true,--enable-libfreetype )dnl
    ifelse(FFMPEG_ENABLE_X11,false,--disable-xlib --disable-sdl2 )dnl
    ifelse(FFMPEG_ENABLE_HWACCELS,true,,--disable-hwaccels )dnl
    ifelse(FFMPEG_ENABLE_LIBMFX,true,--enable-libmfx )dnl
    ifelse(FFMPEG_ENABLE_VAAPI,true,--enable-vaapi ,--disable-vaapi )dnl
    ifelse(FFMPEG_ENABLE_V4L2,true,--enable-libv4l2 --enable-indev=v4l2 )dnl
    ifdef(`BUILD_OPENSSL',ifelse(FFMPEG_OPENSSL_NOBIND,true,,`--enable-openssl --extra-ldflags=-Wl`,'-rpath=BUILD_PREFIX/ssl/lib '))dnl
    ifdef(`BUILD_LIBFDKAAC',--enable-libfdk-aac )dnl
    ifdef(`BUILD_LIBOPUS',--enable-libopus )dnl
    ifdef(`BUILD_LIBVPX',--enable-libvpx ,--disable-libvpx )dnl
    ifdef(`BUILD_LIBVORBIS',--enable-libvorbis )dnl
    ifdef(`BUILD_LIBX264',--enable-gpl --enable-libx264 )dnl
    ifdef(`BUILD_LIBX265',--enable-gpl --enable-libx265 )dnl
    ifdef(`BUILD_SVT_AV1',--enable-libsvtav1 )dnl
    ifdef(`BUILD_LIBAOM',--enable-libaom )dnl
    ifdef(`BUILD_LIBVMAF',--enable-libvmaf --enable-version3 )dnl
    ifdef(`BUILD_DAV1D',--enable-libdav1d )dnl
    ifdef(`BUILD_ONEVPL_DISP',--enable-libvpl )dnl
    && make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
ifdef(`REBUILD_OPENCV_VIDEOIO',`dnl
ifelse(index(IMAGE,`sg2'),-1,`
#REBUILD_OPENCV_VIDEOIO()dnl
')dnl
')dnl
')

REG(FFMPEG)

include(end.m4)dnl
