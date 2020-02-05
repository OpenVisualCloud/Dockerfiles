# load qat driver
ADD qat-driver.tar.gz /
RUN tar cf - /opt/intel/QAT | (mkdir -p /home/build && cd /home/build && tar xf -)
