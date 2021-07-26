file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/dldt_gst_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if(NOT "${image}" MATCHES "vcaca" AND ${name} MATCHES "vcaca")
    #Do not add vcaca test to non-vcaca images
    elseif(("${image}" MATCHES "vcaca") AND NOT (${name} MATCHES "vcaca"))
    #Do not add non-vcaca video analytics test to vcaca
    elseif("${image}" MATCHES "dev" AND ${name} MATCHES "video_analytics")
    #Do not add analytics test case with 264 in dev images
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
