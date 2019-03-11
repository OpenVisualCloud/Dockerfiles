#example for ospray xfrog-forest

ARG EXAMPLE_PATH=http://www.sdvis.org/ospray/download/demos/XFrogForest/xfrog-forest.tar.bz2
ARG EXAMPLE_NAME=xfrog-forest
RUN wget ${EXAMPLE_PATH}; \
    mkdir example; \
    tar -xaf ${EXAMPLE_NAME}* -C example; \
    rm -f ${EXAMPLE_NAME}*
