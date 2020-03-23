This docker image is part of Open Visual Cloud software stacks. Optimized for for video conferencing service based on the WebRTC technology and Open WebRTC Toolkit (OWT). Docker image optimized for ultra-high resolution immersive video low latency streaming, based on the WebRTC technology and the Open WebRTC Toolkit. Included SVT-HEVC tile-based 4K and 8K transcoding and field of view (FoV) adaptive streaming. The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [xeon-centos-76-service-owt-immersive](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/Xeon/centos-7.6/service/owt-immersive/Dockerfile)

## Quick reference
- #### Supported platform and OS
Intel&reg; Xeon&reg; platform, CentOS-7.6.1810

- #### Included components:
[OWT-Immersive](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/owt-immersive.md)	


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
