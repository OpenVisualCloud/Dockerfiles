file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/ffmpeg_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if("${image}" MATCHES "vcaca" AND ${name} MATCHES "(svt|hevc|av1?)")
    #Do not add svt test for VCACA DEV image
    elseif(${image} MATCHES "analytics" AND ${name} STREQUAL "ffmpeg_vmaf")
    #Do not add vmaf test for analytics image
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
