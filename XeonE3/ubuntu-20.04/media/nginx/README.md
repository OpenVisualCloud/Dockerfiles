This docker image is part of Open Visual Cloud software stacks. Optimized for the media creation and delivery use case. Optimized for NGINX web server that can be used for serving web content, load balancing, HTTP caching, or a reverse proxy. Also included Intel hardware accelaration software stack such as media SDK, media driver, gmmlib and libva. The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [xeone3-ubuntu-2004-media-nginx](https://github.com/OpenVisualCloud/Dockerfiles/blob/v22.3/XeonE3/ubuntu-20.04/media/nginx/Dockerfile)

## Quick reference
- #### Supported platform and OS
  Intel&reg; Xeon&reg; E3 platform, Ubuntu 20.04

- #### Usage instructions:
  [NGINX](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/nginx.md)	


- #### Getting started with Dockerfiles:
  [OpenVisualCloud Dockerfiles Wiki](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

- #### File issues:
  [OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)


## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.


| Components | License |
| ----- | ----- |
|Ubuntu| [Various](https://hub.docker.com/_/ubuntu) |
|nginx http flv|BSD 2-clause "Simplified" License|
|nginx upload module|BSD 3-clause "Simplified" License|
|nginx|BSD 2-clause "Simplified" License|
|libogg|BSD 3-clause "New" or "Revised" License|
|libvorbis|BSD 3-clause "New" or "Revised" License|
|Opus Interactive Audio Codec|BSD 3-clause "New" or "Revised" License|
|libvpx|BSD 3-clause "New" or "Revised" License|
|x264|GNU General Public License v2.0 or later|
|x265|GNU General Public License v2.0 or later|
|dav1d|BSD 2-clause "Simplified" License|
|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|
|Intel SVT-AV1|BSD-2-Clause Plus Patent License|
|Intel SVT-VP9|BSD-2-Clause Plus Patent License|
|Intel Graphics Memory Management Library| MIT License|
|Intel libva| MIT License
|Intel media driver | MIT License|
|Intel media SDK|MIT License|
|OpenCV|BSD 3-clause "New" or "Revised" License|
|FFmpeg|GNU General Public License v2.0 or later|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
