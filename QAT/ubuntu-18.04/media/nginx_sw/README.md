This docker image is part of Open Visual Cloud software stacks. Optimized for NGINX web server with compute-intensive operations acceleration with Intel® QuickAssist Technology (Intel® QAT).The docker image can be used in the FROM field of a downstream Dockerfile.
This Image implements Software Implementation of [QAT-Engine](https://github.com/intel/QAT_Engine).
Refer to [Nginx image](https://github.com/OpenVisualCloud/Dockerfiles/tree/master/QAT/ubuntu-18.04/media/nginx) for Hardware Implementation.

## Supported tags and respective Dockerfile links
 - [qat-ubuntu-1804-media-nginx_sw](https://github.com/OpenVisualCloud/Dockerfiles/blob/v22.3/QAT/ubuntu-18.04/media/nginx_sw/Dockerfile)

## Quick reference
- #### Supported platform and OS
  Intel&reg; QAT platform, Ubuntu 18.04

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
|QATzip|BSD 3-clause "New" or "Revised" License|
|OpenSSL|Apache License 2.0|
|ipp crypo|Apache-2.0 License|
|QAT OpenSSL engine|BSD 3-clause "New" or "Revised" License|
|nginx http flv|BSD 2-clause "Simplified" License|
|nginx upload module|BSD 3-clause "Simplified" License|
|asynch mode nginx |BSD 3-clause "New" or "Revised" License|
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
|OpenCV|BSD 3-clause "New" or "Revised" License|
|FFmpeg|GNU General Public License v2.0 or later|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
