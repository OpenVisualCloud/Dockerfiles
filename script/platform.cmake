file(GLOB os_dirs "*")
foreach(dir ${os_dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()

add_custom_target(update_${platform}_link COMMAND ${CMAKE_SOURCE_DIR}/script/update-imagelist.sh ${DOCKER_PREFIX} ${platform} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
add_dependencies(update_link update_${platform}_link)
