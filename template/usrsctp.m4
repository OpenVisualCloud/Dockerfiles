# Build usrsctp

ARG USRSCTP_VERSION="30d7f1bd0b58499e1e1f2415e84d76d951665dc8"
ARG USRSCTP_FILE="${USRSCTP_VERSION}.tar.gz"
ARG USRSCTP_EXTRACT="usrsctp-${USRSCTP_VERSION}"
ARG USRSCTP_URL="https://github.com/sctplab/usrsctp/archive/${USRSCTP_FILE}"

ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q which
)dnl

RUN wget -O - ${USRSCTP_URL} | tar xz && \
    mv ${USRSCTP_EXTRACT} usrsctp && \
    cd usrsctp && \
    ./bootstrap && \
    ./configure --prefix="/usr" && \
    make && \
    make install
