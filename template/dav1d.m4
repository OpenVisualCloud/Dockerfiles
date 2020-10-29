# Install required packges
ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN yum install -y ninja-build python36-setuptools,dnl
RUN apt-get update -y && apt-get install -y --no-install-recommends python3-pip ninja-build python3-setuptools && \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*;
)

# Build Meson
ARG MESON_VER=0.53.1
ARG MESON_REPO=https://github.com/mesonbuild/meson

RUN git clone ${MESON_REPO}; \
    cd meson; \
    git checkout ${MESON_VER}; \
    ifelse(index(DOCKER_IMAGE,ubuntu),-1,python3.6,python3) setup.py install;

# Build dav1d
ARG LIBDAV1D_VER=0.5.2
ARG LIBDAV1D_REPO=https://code.videolan.org/videolan/dav1d.git

define(`FFMPEG_CONFIG_DAV1D',--enable-libdav1d )dnl
RUN  git clone ${LIBDAV1D_REPO}; \
     cd dav1d; \
     git checkout ${LIBDAV1D_VER}; \
     meson build --prefix /usr --libdir ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/lib64,/usr/lib/x86_64-linux-gnu) --buildtype release; \
     ifelse(index(DOCKER_IMAGE,ubuntu),-1,ninja-build,ninja) -C build; \
     cd build; \
     DESTDIR="/home/build" ifelse(index(DOCKER_IMAGE,ubuntu),-1,ninja-build,ninja) install; \
     ifelse(index(DOCKER_IMAGE,ubuntu),-1,ninja-build,ninja) install;

