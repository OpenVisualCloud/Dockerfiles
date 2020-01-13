file(GLOB tests "${DockerFiles_SOURCE_DIR}/test/dldt_ffmpeg_*.sh")
foreach(test ${tests})
    get_filename_component(name ${test} NAME_WE)
    if(NOT "${image}" MATCHES "vcaca" AND ${name} MATCHES "vcaa")
    #Do not add vcaa test to non-vcaa images
    elseif(("${image}" MATCHES "vcaca") AND NOT (${name} MATCHES "vcaa"))
    #Do not add non-vcaa video analytics test to vcaa
    else()
    add_test(test_${image}_${name} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" "/mnt/${name}.sh" "${image}")
    endif()
endforeach()
