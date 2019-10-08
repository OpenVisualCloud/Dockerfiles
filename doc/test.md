### Open Visual Cloud Dockerfiles Development and Test Status:
- C: Compiled. Not yet tested.
- T: Tested. Some tests failed.
- V: Verified. All tests passed.
- -: To be added in subsequent commits.

| Platform: Xeon (CPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | V | V | V |
| Media:NGINX | V | V | V | V | V |
| Media:SVT | V | V | V | V | V |
| Analytics:FFmpeg | V | V | V | V | V |
| Analytics:GStreamer | V | V | V | V | V |
| Graphics:ospray | V | V | V | V | V |
| Graphics:ospray-mpi | V | V | V | V | V |
| Service:OWT | - | V | - | - | V |
| Dev | V | V | V | V | V |

| Platform: XeonE3 (GPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | T | T | T |
| Media:NGINX | V | V | V | V | V |
| Analytics:FFmpeg | V | V | V | V | V |
| Analytics:GStreamer | V | V | T | T | T |
| Service:OWT | - | V | - | - | V |
| Dev | V | V | T | T | T |

| Platform: VCA2 | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| Media:FFmpeg | V | V | V | V | V |
| Media:GStreamer | V | V | T | T | T |
| Media:NGINX | V | V | V | V | V |
| Dev | V | V | T | T | T |

| Platform: VCAC-A | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | 
|-----|:---:|:---:|
| Analytics:FFmpeg | V | T |  
| Analytics:GStreamer | V | V | 
| Dev | V | T |  

Known Issues:
- gst_vaapi_jpegenc/gst_vaapi_h264enc test failed on XeonE3/VCA2 CentOS environment. Issue #210
- VCAC-A-ubuntu1804-analytics-ffmpeg images test failed #214
