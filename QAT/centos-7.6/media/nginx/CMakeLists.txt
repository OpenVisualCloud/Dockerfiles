set(image "qat_media_nginx_centos76")
set(dep_image "xeon_media_ffmpeg_centos76")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "${CMAKE_CURRENT_SOURCE_DIR}/qat-qatzip.tar.gz")
include(image)
