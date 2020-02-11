# load qat
ADD qat.tar.gz /home/build/
RUN mkdir -p /opt/intel /home/build/opt/intel && \
    ln -s /home/build/opt/intel/QAT /opt/intel/QAT
