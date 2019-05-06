/*******************************************************************************
 * Copyright (C) <2019> Intel Corporation
 *
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
