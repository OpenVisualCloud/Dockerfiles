set(image "vca2_nginx_rtmp_centos75")
set(dep_image "vca2_ffmpeg_centos75")
include("${CMAKE_SOURCE_DIR}/script/image.cmake")
include("${CMAKE_SOURCE_DIR}/script/nginx-tests.cmake")
