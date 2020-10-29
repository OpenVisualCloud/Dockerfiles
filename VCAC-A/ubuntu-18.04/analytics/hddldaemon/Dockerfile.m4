
FROM ubuntu:18.04 as builder
WORKDIR /home

include(build-tools-hddl.m4)
include(libusb.m4)
include(openvino.binary.m4)

FROM ubuntu:18.04

include(build-tools-hddl-layer.m4)
COPY --from=builder /lib/x86_64-linux-gnu/libusb-1.0.so.0 /lib/x86_64-linux-gnu/libusb-1.0.so.0
COPY --from=builder /home/opt/intel /opt/intel
COPY *_hddl.sh /usr/local/bin/
