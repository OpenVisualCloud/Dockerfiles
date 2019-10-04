if(NOT DEFINED image_dirs)
    file(GLOB image_dirs "*")
endif()

foreach(dir ${image_dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()
