file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/ffmpeg_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if(${image} MATCHES "analytics" AND ${name} STREQUAL "ffmpeg_vmaf")
    #Do not add vmaf test for analytics image
    elseif(NOT ${image} MATCHES "vmaf" AND ${name} STREQUAL "ffmpeg_vmaf")
    #Do not add vmaf test to non vmaf images
    elseif(${image} MATCHES "dev" AND ${name} MATCHES "(1dns|x265|x264?)")
    #Do not add GPL component tests for dev image
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
