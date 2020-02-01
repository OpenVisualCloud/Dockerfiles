file(GLOB os_dirs "*")

foreach(dir ${os_dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()
