# Fetch gmmlib
ARG GMMLIB_VER=intel-gmmlib-18.3.0
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz

RUN wget --no-check-certificate -O - ${GMMLIB_REPO} | tar xz && mv gmmlib-${GMMLIB_VER} gmmlib;

