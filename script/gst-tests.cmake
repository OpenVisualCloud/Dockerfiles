file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/gst_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if(NOT ${BUILD_MP3LAME} AND ${name} STREQUAL "gst_lamemp3")
    #Do not add the gst_lamemp3 test if the flag BUILD_MP3LAME is OFF
    elseif(NOT ${BUILD_FDKAAC} AND ${name} STREQUAL "gst_fdkaac")
    #Do not add the gst_fdkaac test if the flag BUILD_FDKAAC is OFF
    elseif(${image} MATCHES "vcaca_ffmpeg_gst_devel" AND ${name} MATCHES "gst_svt")
    #Do not add svt test for VCACA DEV image
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
