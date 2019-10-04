if(NOT DEFINED usage_dirs)
    file(GLOB usage_dirs "*")
endif()

foreach(dir ${usage_dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()
