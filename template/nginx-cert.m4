# Generate a self-certificate for testing purpose
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir -p /home/build/etc/nginx && \
    printf "US\nOR\nPortland\nOregon\nData Center Group\nIntel Corporation\n%s\nnobody@intel.com\n" "$(hostname)" | /opt/openssl/bin/openssl req -x509 -nodes -days 30 -newkey rsa:4096 -keyout /home/build/etc/nginx/cert.key -out /home/build/etc/nginx/cert.crt && \
    chmod 640 /home/build/etc/nginx/cert.key && \
    chmod 644 /home/build/etc/nginx/cert.crt
