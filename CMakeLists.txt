cmake_minimum_required (VERSION 2.8)

Project(DockerFiles NONE)

if (NOT DEFINED SECURITY_STRICT)
    set(SECURITY_STRICT "No")
endif()

enable_testing()

file(GLOB dirs "*")
foreach(dir ${dirs})
    if(EXISTS ${dir}/CMakeLists.txt)
        add_subdirectory(${dir})
    endif()
endforeach()

# legal message
message(
    "\nThis script will build third party components licensed under various open source licenses into your container images.\n"
    "The terms under which those components may be used and distributed can be found with the license document that is provided with those components.\n"
    "Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.\n"
    "\n-- Setting: SECURITY_STRICT=${SECURITY_STRICT}\n")

