file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/gst_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if(NOT ${BUILD_FDKAAC} AND ${name} STREQUAL "gst_fdkaac")
    #Do not add the gst_fdkaac test if the flag BUILD_FDKAAC is OFF
    elseif(${image} MATCHES "dev" AND ${name} MATCHES "(x264|x265?)")
    #Do not add GPL component test for DEV images
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
