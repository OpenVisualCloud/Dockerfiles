FROM xeon-ubuntu1804-ffmpeg-gst-dev:1.0 AS build
COPY main.cpp /main.cpp
RUN gcc -I/usr/include -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include/ -I/usr/include/gstreamer-1.0 -o hellogst /main.cpp -lglib-2.0 -lgstreamer-1.0

FROM xeon-ubuntu1804-dldt-gst:1.0
COPY --from=build /home/hellogst /home/hellogst
RUN dd if=/dev/urandom bs=115200 count=300 of=/home/test.yuv
ENTRYPOINT ["/home/hellogst"]
