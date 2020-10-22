This docker image is part of Open Visual Cloud software stacks. This is development image aim towards enabling C++ application compilation, debugging (with the debugging, profiling tools) and optimization (with the optimization tools.) You can compile C++ applications with this image and then copy the applications to the corresponding deployment image. The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [xeon-ubuntu-1804-service-dev](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/Xeon/ubuntu-18.04/service/dev/Dockerfile)

## Quick reference
- #### Supported platform and OS
  Intel&reg; Xeon&reg; platform, Ubuntu 18.04

- #### Usage instructions:
  [FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)	[GStreamer](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/gst.md)	


- #### Getting started with Dockerfiles:
  [OpenVisualCloud Dockerfiles Wiki](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

- #### File issues:
  [OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)


## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.


| Components | License |
| ----- | ----- |
|Ubuntu| [Various](https://hub.docker.com/_/ubuntu) |
|libnice|GNU Lesser General Public License|
|openssl|Apache License 2.0|
|libre|BSD 3-clause License|
|usrsctp|BSD 3-clause "New" or "Revised" License|
|libsrtp2|BSD 3-clause License|
|FFmpeg|GNU Lesser General Public License v2.1 or later|
|nodejs| MIT Open Source License|
|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|
|owt-server|Apache License v2.0|
|owt-sdk|Apache License v2.0|
|owt-deps-webrtc|BSD 3-clause License|
|nodejs| MIT Open Source License|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
