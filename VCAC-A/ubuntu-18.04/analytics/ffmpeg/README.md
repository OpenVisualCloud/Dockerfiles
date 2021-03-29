This docker image is part of Open Visual Cloud software stacks. Optimized for Media Analytics. Included what are in media delivery FFmpeg image, inferencing engine and video analytics plugins. Also included Intel hardware accelaration software stack such as media SDK, media driver, opencl, gmmlib and libva. The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [vcac-a-ubuntu-1804-analytics-ffmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/v21.3/VCAC-A/ubuntu-18.04/analytics/ffmpeg/Dockerfile)

## Quick reference
- #### Supported platform and OS
  Intel&reg; VCAC-A platform, Ubuntu 18.04

- #### Usage instructions:
  [FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)	


- #### Getting started with Dockerfiles:
  [OpenVisualCloud Dockerfiles Wiki](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

- #### File issues:
  [OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)


## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.


| Components | License |
| ----- | ----- |
|Ubuntu| [Various](https://hub.docker.com/_/ubuntu) |
|libogg|BSD 3-clause "New" or "Revised" License|
|libvorbis|BSD 3-clause "New" or "Revised" License|
|Opus Interactive Audio Codec|BSD 3-clause "New" or "Revised" License|
|libvpx|BSD 3-clause "New" or "Revised" License|
|x264|GNU General Public License v2.0 or later|
|x265|GNU General Public License v2.0 or later|
|dav1d|BSD 2-clause "Simplified" License|
|Intel Graphics Memory Management Library| MIT License|
|Intel libva| MIT License
|Intel opencl | MIT License|
|Intel media driver | MIT License|
|Intel media SDK|MIT License|
|OpenVINO|End User License Agreement for the Intel(R) Software Development Products|
|json-c|MIT License|
|librdkafka|BSD 2-clause "Simplified" License|
|OpenCV|BSD 3-clause "New" or "Revised" License|
|FFmpeg|GNU Lesser General Public License v2.1 or later|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
