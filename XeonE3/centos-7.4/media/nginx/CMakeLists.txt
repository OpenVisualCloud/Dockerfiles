set(image "xeone3_nginx_rtmp_centos74")
set(dep_image "xeone3_ffmpeg_centos74")
include("${CMAKE_SOURCE_DIR}/script/image.cmake")
include("${CMAKE_SOURCE_DIR}/script/nginx-tests.cmake")
