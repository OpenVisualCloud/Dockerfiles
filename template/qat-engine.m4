# Build QAT Engine
ARG QAT_ENGINE_VER=v0.5.42
ARG QAT_ENGINE_REPO=https://github.com/intel/QAT_Engine/archive/${QAT_ENGINE_VER}.tar.gz

ADD qat-driver.tar.gz /
RUN wget -O - ${QAT_ENGINE_REPO} | tar xz && \
    cd QAT_Engine* && \
    ./autogen.sh && \
    ./configure --with-qat_dir=/opt/intel/QAT --with-openssl_dir=/home/openssl --with-openssl_install_dir=/opt/openssl --enable-upstream_driver --enable-usdm --prefix=/opt/intel/qat-engine && \
    PERL5LIB=/home/openssl make -j8 && \
    PERL5LIB=/home/openssl make install DESTDIR=/home/build && \
    PERL5LIB=/home/openssl make install 

