#build ISPC

ARG ISPC_VER=1.9.1
ARG ISPC_REPO=https://github.com/ispc/ispc/releases/download/v${ISPC_VER}/ispc-v${ISPC_VER}b-linux.tar.gz
RUN wget -O - ${ISPC_REPO} | tar xz
ENV ISPC_EXECUTABLE=/home/ispc-v${ISPC_VER}-linux/ispc
