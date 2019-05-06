This is a hello world example using the development and deployment images to build a gstreamer application

Prerequisites:
Build the Xeon/ubuntu-18.04/dldt+gst and Xeon/ubuntu-18.04/ffmpeg+gst+dev images with the instructions on the main page

To build the sample:

docker build . --tag hellogstreamer

To run the sample:

docker run --rm hellogstreamer


Dockerfile

FROM xeon-ubuntu1804-ffmpeg-gst-dev:1.0 AS build
COPY main.cpp /main.cpp
RUN gcc -I/usr/include -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include/ -I/usr/include/gstreamer-1.0 -o hellogst /main.cpp -lglib-2.0 -lgstreamer-1.0

FROM xeon-ubuntu1804-dldt-gst:1.0
COPY --from=build /home/hellogst /home/hellogst
RUN dd if=/dev/urandom bs=115200 count=300 of=/home/test.yuv
ENTRYPOINT ["/home/hellogst"]

main.cpp

/*******************************************************************************
 * Copyright (C) <2019> Intel Corporation
 ******************************************************************************/

#include <dirent.h>
#include <gio/gio.h>
#include <gst/gst.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Parse arguments
    gst_init(&argc, &argv);
    GError *error = NULL;

    // Build the pipeline
    auto launch_str = g_strdup_printf("filesrc location=/home/test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! "
                                      "x264enc ! mpegtsmux ! filesink location=test.ts");
    g_print("PIPELINE: %s \n", launch_str);
    GstElement *pipeline = gst_parse_launch(launch_str, NULL);
    g_free(launch_str);

    // Start playing
    gst_element_set_state(pipeline, GST_STATE_PLAYING);

    // Wait until error or EOS
    GstBus *bus = gst_element_get_bus(pipeline);

    int ret_code = 0;

    GstMessage *msg = gst_bus_poll(bus, (GstMessageType)(GST_MESSAGE_ERROR | GST_MESSAGE_EOS), -1);

    if (msg && GST_MESSAGE_TYPE(msg) == GST_MESSAGE_ERROR) {
        GError *err = NULL;
        gchar *dbg_info = NULL;

        gst_message_parse_error(msg, &err, &dbg_info);
        g_printerr("ERROR from element %s: %s\n", GST_OBJECT_NAME(msg->src), err->message);
        g_printerr("Debugging info: %s\n", (dbg_info) ? dbg_info : "none");

        g_error_free(err);
        g_free(dbg_info);
        ret_code = -1;
    }

    if (msg)
        gst_message_unref(msg);

    // Free resources
    gst_object_unref(bus);
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);

    return ret_code;
}

