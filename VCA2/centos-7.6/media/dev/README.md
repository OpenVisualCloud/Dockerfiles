This docker image is part of Open Visual Cloud software stacks. This is development image aim towards  enabling C++ application compilation, debugging (with the debugging, profiling tools) and optimization (with the optimization tools.) You can compile C++ applications with this image and then copy the applications to the corresponding deployment image. Image for FFmpeg or GStreamer C++ application development for Media creation and media delivery. The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [vca2-centos-76-media-dev](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/VCA2/centos-7.6/media/dev/Dockerfile)

## Quick reference
- #### Supported platform and OS
Intel&reg; VCA2 platform, CentOS-7.6.1810

- #### Included components:
[FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)	[GStreamer](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/gst.md)	


- #### Where to get help:
- [Open Visual Cloud Dockerfiles Github](https://github.com/OpenVisualCloud/Dockerfiles)
- [Getting Started With Open Visual Cloud Docker Files](https://01.org/openvisualcloud/documents/get-started-docker)
- [the Docker Community Forums](https://forums.docker.com)
- [the Docker Community Slack](https://www.docker.com/docker-community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)

-  #### Where to file issues:
[OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)

- #### Maintained by:
[OpenVisualCloud Dockerfiles Community](https://github.com/OpenVisualCloud/Dockerfiles/graphs/contributors)


## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.


| Components | License |
| ----- | ----- |
|CentOS| [Various](https://hub.docker.com/_/centos) |
|libogg|BSD 3-clause "New" or "Revised" License|
|libvorbis|BSD 3-clause "New" or "Revised" License|
|Opus Interactive Audio Codec|BSD 3-clause "New" or "Revised" License|
|libvpx|BSD 3-clause "New" or "Revised" License|
|Aomedia AV1 Codec Library|BSD 2-clause "Simplified" License|
|x264|GNU General Public License v2.0 or later|
|x265|GNU General Public License v2.0 or later|
|dav1d|BSD 2-clause "Simplified" License|
|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|
|Intel SVT-AV1|BSD-2-Clause Plus Patent License|
|Intel SVT-VP9|BSD-2-Clause Plus Patent License|
|Intel Graphics Memory Management Library| MIT License|
|libdrm|MIT license|
|Intel libva| MIT License
|Intel media-driver | MIT License|
|Intel media SDK|MIT License|
|gstreamer|GNU Lesser General Public License v2.1 or later|
|gst plugin base|GNU Lesser General Public License v2.1 or later|
|gst plugin good|GNU Lesser General Public License v2.1 or later|
|gst plugin bad|GNU Lesser General Public License v2.1 or later|
|gst plugin ugly|GNU Lesser General Public License v2.1 or later|
|gst plugin libav|GNU Lesser General Public License v2.1 or later|
|gst plugin svt|GNU Lesser General Public License v2.1 or later|
|gst plugin vaapi|GNU Lesser General Public License v2.1 or later|
|FFmpeg|GNU Lesser General Public License v2.1 or later|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
