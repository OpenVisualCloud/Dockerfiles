ifelse(index(DOCKER_IMAGE,-dev),-1,
# Clean up after build
RUN rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;
)dnl
