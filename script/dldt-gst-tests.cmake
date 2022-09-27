file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/dldt_gst_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if("${image}" MATCHES "dev" AND ${name} MATCHES "video_analytics")
    #Do not add analytics test case with 264 in dev images
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
