# Build QAT Engine
ARG QAT_ENGINE_VER=v0.5.42
ARG QAT_ENGINE_REPO=https://github.com/intel/QAT_Engine/archive/${QAT_ENGINE_VER}.tar.gz

RUN wget -O - ${QAT_ENGINE_REPO} | tar xz && \
    cd QAT_Engine* && \
    ./autogen.sh && \
    ./configure --with-qat_dir=/opt/intel/QAT --with-openssl_dir=/home/openssl --with-openssl_install_dir=/opt/openssl --enable-upstream_driver --enable-usdm --prefix=/opt/intel/QATengine --enable-qat_debug && \
    PERL5LIB=/home/openssl make -j8 && \
    PERL5LIB=/home/openssl make install && \
    tar cf - /opt/openssl | (cd /home/build && tar xf -)

define(`INSTALL_QAT_OPENSSL',dnl
ENV OPENSSL_ENGINES=/opt/openssl/lib/engines-1.1
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64
)dnl

