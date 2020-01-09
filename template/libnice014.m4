# Build libnice
ARG NICE_VER="0.1.4"
ARG NICE_REPO=http://nice.freedesktop.org/releases/libnice-${NICE_VER}.tar.gz
ARG LIBNICE_PATCH_REPO_01=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-agentlock.patch
ARG LIBNICE_PATCH_REPO_02=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-agentlock-plus.patch
ARG LIBNICE_PATCH_REPO_03=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-removecandidate.patch
ARG LIBNICE_PATCH_REPO_04=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-keepalive.patch
ARG LIBNICE_PATCH_REPO_05=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-startcheck.patch

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q glib2-devel
)dnl

RUN wget -O - ${NICE_REPO} | tar xz && \
    cd libnice-${NICE_VER} && \
    wget -O - ${LIBNICE_PATCH_REPO_01} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_02} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_03} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_04} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_05} | patch -p1 && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) && \
    make -s V= && \
    make install
