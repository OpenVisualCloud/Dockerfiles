### Open Visual Cloud Dockerfiles Development and Test Status:
- C: Compiled. Not yet tested.
- T: Tested. Some tests failed.
- V: Verified. All tests passed.
- -: To be added in subsequent commits.

| Platform: Xeon (CPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | V | V | V |
| Media:NGINX | T | T | T | T | T |
| Media:SVT | V | V | V | V | V |
| Analytics:FFmpeg | V | V | V | V | V |
| Analytics:GStreamer | V | V | V | V | V |
| Graphics:ospray | V | V | V | V | V |
| Graphics:ospray-mpi | V | V | V | V | V |
| Service:OWT | - | V | - | - | T |
| Dev | V | V | V | V | V |

| Platform: XeonE3 (GPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | V | V | V |
| Media:NGINX | T | T | T | T | T |
| Analytics:FFmpeg | V | V | V | V | V |
| Analytics:GStreamer | V | V | V | V | V |
| Service:OWT | - | T | - | - | T |
| Dev | V | V | V | V | V |

| Platform: VCA2 | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | V | V | V |
| Media:NGINX | T | T | T | T | T |
| Dev | V | V | V | V | V |

Known Issues:
- NGINX RTMP module is not stable when testing. Issue #111
- OWT test fails on CentOS. Issue #161
