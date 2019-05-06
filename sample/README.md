This is a hello world example using the development and deployment images to build a gstreamer application

Prerequisites:
Build the Xeon/ubuntu-18.04/dldt+gst and Xeon/ubuntu-18.04/ffmpeg+gst+dev images with the instructions on the main page

To build the sample:

docker build . --tag hellogstreamer

To run the sample:

docker run --rm hellogstreamer
