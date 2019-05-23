COPY --from=build /home/build/owt /home/owt

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN echo -e "\x1b[32mInstalling dependent components and libraries via apt-get...\x1b[0m" && \
    apt-get update && \
    apt-get install rabbitmq-server mongodb libboost-system-dev libboost-thread-dev liblog4cxx-dev libglib2.0-0 libfreetype6-dev -y && \
    rm -rf /var/lib/apt/lists/*;
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install epel-release boost-system boost-thread log4cxx glib2 freetype-devel -y && \	
    yum install rabbitmq-server mongodb mongodb-server -y && \
    yum remove -y -q epel-release && \
    rm -rf /var/cache/yum/*;
)dnl
