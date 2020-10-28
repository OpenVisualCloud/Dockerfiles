ifelse(index(DOCKER_IMAGE,-dev),-1,COPY --from=build /home/owt-server/dist /home/owt,)
COPY --from=build /home/build /

ifelse(index(DOCKER_IMAGE,-dev),-1,,ENV LD_LIBRARY_PATH=/usr/local/ssl/lib)

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu):ifelse(index(DOCKER_IMAGE,xeon-),-1,/opt/intel/mediasdk/lib64,)
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN ifelse(index(DOCKER_IMAGE,xeon-),-1,ln -s /opt/intel/mediasdk/lib /opt/intel/mediasdk/lib64 &&,) echo -e "\x1b[32mInstalling dependent components and libraries via apt-get...\x1b[0m" && \
    touch /home/test && \
    sed -i "/lssl/i\'\-L\/usr\/local\/ssl\/lib\'`,'" ifelse(BUILD_DEV,enabled,/home/owt-server/source/agent/webrtc/webrtcLib/binding.gyp && \,/home/test && \)
    rm /home/test && apt-get update && \
    apt-get install --no-install-recommends rabbitmq-server mongodb libboost-system-dev libboost-thread-dev liblog4cxx-dev libglib2.0-0 libfreetype6-dev curl -y && \ 
    ifelse(index(DOCKER_IMAGE,-dev),-1,,apt-get install --no-install-recommends git pkg-config libglib2.0-dev g++ -y && \)
    ifelse(index(DOCKER_IMAGE,xeon-),-1,apt-get install intel-gpu-tools libgl1-mesa-dev libvdpau-dev -y && \)
    ifelse(index(DOCKER_IMAGE,-dev),-1,echo "#!/bin/bash -e" >> /home/launch.sh && \
    echo "service mongodb start &" >> /home/launch.sh && \
    echo "service rabbitmq-server start &" >> /home/launch.sh && \
    echo "while ! mongo --quiet --eval \"db.adminCommand('listDatabases')\"" >> /home/launch.sh && \
    echo "do" >> /home/launch.sh && \
    echo "  echo mongod not launch" >> /home/launch.sh && \
    echo "  sleep 1" >> /home/launch.sh && \
    echo "done" >> /home/launch.sh && \
    echo "echo mongodb connected successfully" >> /home/launch.sh && \
    echo "cd /home/owt" >> /home/launch.sh && \
    ifelse(index(DOCKER_IMAGE,xeon-),-1,echo "./video_agent/init.sh --hardware" >> /home/launch.sh && \)
    echo "./management_api/init.sh && ./bin/start-all.sh " >> /home/launch.sh && \
    chmod +x /home/launch.sh && \
    export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \,)
    rm -rf /var/lib/apt/lists/*;
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN echo "[mongodb-org-3.6]" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    yum install epel-release boost-system boost-thread log4cxx glib2 freetype-devel -y && \
    yum install rabbitmq-server mongodb-org -y && \
    yum remove -y -q epel-release && \
    ifelse(index(DOCKER_IMAGE,xeon-),-1,
        yum install intel-gpu-tools mesa-libGL-devel libvdpau -y && \
    )dnl
    echo "#!/bin/bash -e" >> /home/launch.sh && \
    echo "mongod --config /etc/mongod.conf &" >> /home/launch.sh && \
    echo "rabbitmq-server &" >> /home/launch.sh && \
    echo "while ! mongo --quiet --eval \"db.adminCommand('listDatabases')\"" >> /home/launch.sh && \
    echo "do" >> /home/launch.sh && \
    echo "  sleep 1" >> /home/launch.sh && \
    echo "done" >> /home/launch.sh && \
    echo "echo mongodb connected successfully" >> /home/launch.sh && \
    echo "cd /home/owt" >> /home/launch.sh && \
    ifelse(index(DOCKER_IMAGE,xeon-),-1,
        echo "./video_agent/init.sh --hardware" >> /home/launch.sh && \
    )dnl
    echo "./management_api/init.sh && ./bin/start-all.sh " >> /home/launch.sh && \
    chmod +x /home/launch.sh && \
    export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
    rm -rf /var/cache/yum/*;
)dnl
ifelse(index(DOCKER_IMAGE,xeon-),-1,
    ENV LIBVA_DRIVER_NAME=iHD
)dnl
