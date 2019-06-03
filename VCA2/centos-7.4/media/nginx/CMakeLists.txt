set(image "vca2_nginx_rtmp_centos74")
set(dep_image "vca2_ffmpeg_centos74")
include("${CMAKE_SOURCE_DIR}/script/image.cmake")
include("${CMAKE_SOURCE_DIR}/script/nginx-tests.cmake")
