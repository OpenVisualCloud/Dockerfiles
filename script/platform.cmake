if(NOT DEFINED os_dirs)
    file(GLOB os_dirs "*")
endif()

foreach(dir ${os_dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()
