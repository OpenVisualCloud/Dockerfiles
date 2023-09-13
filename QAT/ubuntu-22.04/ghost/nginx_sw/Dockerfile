# Copyright (C) <2023-2023> Intel Corporation
# SPDX-License-Identifier: MIT

ARG BASIC_IMAGE=

####################################################################
#                Developing container image                        #
#    Prepare optimized Node binary for 'ghost.js' workload         #
####################################################################
FROM ubuntu:22.04 as build
LABEL maintainer="daoming.qiu@intel.com"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Los_Angeles
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY patch_ab_TLS1.3.diff /apache/

RUN apt-get update && \
    apt-get install -y build-essential git curl sudo \
    ca-certificates cmake ssh wget vim nano openssl libssl-dev pkg-config \
    autoconf automake libpcre3-dev libexpat1 libexpat1-dev \
    gcc-10 g++-10 cpp-10 && \
    apt-get remove -y unattended-upgrades
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10

RUN cd /apache/ && \
    curl -OkL http://archive.apache.org/dist/httpd/httpd-2.4.53.tar.gz && \
    tar zxvf httpd-2.4.53.tar.gz && \
    cd httpd-2.4.53 && \
    patch -p1 <../patch_ab_TLS1.3.diff && \
    cd srclib && \
    curl -OkL https://archive.apache.org/dist/apr/apr-1.7.0.tar.gz && \
    curl -OkL https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz && \
    tar zxvf apr-1.7.0.tar.gz && \
    mv apr-1.7.0/ apr/ && \
    tar zxvf apr-util-1.6.1.tar.gz && \
    mv apr-util-1.6.1/ apr-util/ && \
    cd .. && \
    ./configure && \
    make -j

# For async nginx building(Intel-specific
RUN apt-get update && \
    apt-get install -y cpuid libtool libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev nasm && \
    apt-get remove -y unattended-upgrades

ARG OPENSSL_RELEASE="OpenSSL_1_1_1j"
RUN git clone -b $OPENSSL_RELEASE https://github.com/openssl/openssl.git
RUN cd ./openssl && \
    ./config && \
    make depend && \
    make && \
    make install_sw

ARG IPP_CRYPTO_VERSION="ipp-crypto_2021_8"
RUN git clone -b $IPP_CRYPTO_VERSION https://github.com/intel/ipp-crypto && \
    cd ./ipp-crypto/sources/ippcp/crypto_mb && \
    cmake . -B"../build" \
      -DOPENSSL_INCLUDE_DIR=/usr/local/include/openssl \
      -DOPENSSL_LIBRARIES=/usr/local/lib \
      -DOPENSSL_ROOT_DIR=/usr/local/bin/openssl && \
    cd ../build && \
    make crypto_mb && \
    make install

ARG IPSEC_MB_VERSION="v1.3"
RUN git clone -b $IPSEC_MB_VERSION https://github.com/intel/intel-ipsec-mb && \
    cd ./intel-ipsec-mb && \
    make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y && \
    make install NOLDCONFIG=y PREFIX=/usr/local/

ARG QAT_ENGINE_VERSION="v1.0.0"
RUN git clone -b $QAT_ENGINE_VERSION https://github.com/intel/QAT_Engine.git && \
    cd ./QAT_Engine && \
    ./autogen.sh && \
    ./configure \
      --with-openssl_install_dir=/usr/local/ \
      --with-qat_sw_install_dir=/usr/local/ \
      --enable-qat_sw && \
    make && \
    make install

ARG ASYNC_NGINX_VERSION="v0.5.0"
RUN git clone -b $ASYNC_NGINX_VERSION https://github.com/intel/asynch_mode_nginx.git && \
    cd ./asynch_mode_nginx && \
    ./configure \
      --prefix=/var/www \
      --conf-path=/usr/local/share/nginx/conf/nginx.conf \
      --sbin-path=/usr/local/bin/nginx \
      --pid-path=/run/nginx.pid \
      --lock-path=/run/lock/nginx.lock \
      --modules-path=/var/www/modules/ \
      --without-http_rewrite_module \
      --with-http_ssl_module \
      --with-pcre \
      --add-dynamic-module=modules/nginx_qat_module/ \
      --with-cc-opt="-DNGX_SECURE_MEM -I/usr/local/include/openssl -Wno-error=deprecated-declarations -Wimplicit-fallthrough=0" \
      --with-ld-opt="-Wl,-rpath=/usr/local/lib -L/usr/local/lib" \
      --user=root \
      --group=root && \
    make && \
    make install

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/openssl:/usr/local/lib
# 从其他位置或URL复制库文件到容器中的适当位置
RUN cp /openssl/libssl.so.1.1 /usr/local/lib/


####################################################################
#                Production container image                        #
#    Integrate patched ab binary into ghost.js workload            #
####################################################################
FROM ubuntu:22.04
LABEL authors="daoming.qiu@intel.com"

ENV USERNAME="ghost"

ARG DEBIAN_FRONTEND="noninteractive"
ARG TZ="America/Los_Angeles"
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
# Install required packages that are not included in ubuntu core image
RUN apt-get update && apt-get install -y \
    mysql-server wget curl build-essential wrk vim \
    sysstat \
    sudo \
    apache2-utils \
    nginx \
    openssl && \
    rm -rf /var/lib/apt/lists/*

# Copy patched ab binary and overwrite default one
COPY --from=build /apache/httpd-2.4.53/support/.libs/ab /usr/bin/ab

COPY --from=build /usr/local/ /usr/local/
COPY --from=build /var/www/ /var/www/
ENV OPENSSL_ENGINES=/usr/local/lib/engines-1.1
RUN ldconfig
RUN /bin/bash -c 'mkdir -p /usr/local/ssl/;cp /etc/ssl/openssl.cnf /usr/local/ssl/'

# Create new Linux account
RUN useradd -rm -d /home/${USERNAME} -s /bin/bash -g root -G sudo -u 1001 ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
RUN chown -R ${USERNAME}:root /usr/local/share/nginx/ && \
    chown -R ${USERNAME}:root /var/www/

# Switch to ${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Upload ghost.dump database
COPY ghost.dump /home/${USERNAME}

# Configure mariadb and install ghost database
RUN echo "soft nofile 65536\nhard nofile 65536" | sudo tee -a /etc/security/limits.conf
RUN echo "\n[mysqld]\nopen_files_limit = 65536\nmax_connections = 10240" | sudo tee -a /etc/mysql/my.cnf

COPY setup_db_ghost.sh /tmp/setup_db_ghost.sh
RUN sudo chmod 777 /tmp/setup_db_ghost.sh && /tmp/setup_db_ghost.sh

# Install ghost
WORKDIR /home/${USERNAME}
RUN mkdir ghost-cli

RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash && \
    sudo -E apt-get update && sudo -E apt-get install -y nodejs
# WORKDIR /home/${USERNAME}/1.19.0
RUN sudo -E npm install -g ghost-cli@1.19.0
WORKDIR /home/${USERNAME}
RUN mkdir Ghost
WORKDIR /home/${USERNAME}/Ghost
RUN ghost install 4.40.0 local
RUN ghost status
COPY --chown=${USERNAME}:root config.production.json /home/${USERNAME}/Ghost

WORKDIR /home/${USERNAME}

# Remove node v12.22.1
RUN sudo apt-get remove -y nodejs npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    sudo -E apt-get install -y nodejs
RUN node -v


# Copy in scripts to run the workload
RUN mkdir /home/${USERNAME}/ghost-benchmark-scripts
COPY --chown=${USERNAME}:root entrypoint.sh /usr/local/bin/entrypoint.sh


#nginx
RUN mkdir /home/${USERNAME}/nginx
COPY --chown=${USERNAME}:root nginx.conf.qat-sw /home/${USERNAME}/nginx/nginx.conf
COPY hack.js /home/${USERNAME}/Ghost/hack.js
RUN mkdir /home/${USERNAME}/certificates
WORKDIR /home/${USERNAME}/certificates
RUN openssl req -newkey rsa:2048 -nodes -keyout ./rsa.key -x509 -days 365 -out ./rsa.crt -subj "/C=US/ST=OR/L=IN/O=IN/OU=IN/CN=$(hostname)"
#For DSA encryption later
#RUN openssl ecparam -genkey -out /usr/local/share/nginx/certs/dsa.key -name prime256v1
#RUN openssl req -x509 -new -key /usr/local/share/nginx/certs/dsa.key -out /usr/local/share/nginx/certs/dsa.crt -subj "/C=/ST=/L=/O=/OU=/CN=$(hostname)"
RUN chown -R ${USERNAME}:root /home/${USERNAME}/certificates

WORKDIR /home/${USERNAME}/Ghost

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD [ "bash" ]