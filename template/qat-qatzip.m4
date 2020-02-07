# load qat & qatzip
ADD qat-qatzip.tar.gz /home/build/
RUN mkdir -p /opt/intel && \
    ln -s /home/build/opt/intel/QAT /opt/intel/QAT && \
    ln -s /home/build/usr/lib64/libqat_s.so /usr/lib64/libqat_s.so && \
    ln -s /home/build/usr/lib64/libusdm_drv_s.so /usr/lib64/libusdm_drv_s.so && \
    ln -s /home/build/opt/intel/QATzip /opt/intel/QATzip && \
    (cd /home/build/usr/lib64 && ln -s libqatzip.so libqatzip.so.1) && \
    ln -s /home/build/usr/lib64/libqatzip.so /usr/lib64/libqatzip.so && \
    ln -s /home/build/usr/lib64/libqatzip.so.1 /usr/lib64/libqatzip.so.1
