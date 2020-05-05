cmake_minimum_required (VERSION 2.8)

Project(DockerFiles NONE)

add_custom_target(update_link)
add_custom_target(update_dockerfile)
add_custom_target(generate_readme)
add_custom_target(upload_readme)

if (NOT DEFINED BUILD_VERSION)
    set(BUILD_VERSION "1.0")
endif()

if (NOT DEFINED BUILD_MP3LAME)
    set(BUILD_MP3LAME "ON")
endif()

if (NOT DEFINED BUILD_FDKAAC)
    set(BUILD_FDKAAC "ON")
endif()

if (NOT DEFINED DOCKER_PREFIX)
    set(DOCKER_PREFIX "openvisualcloud")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/script/")

enable_testing()

include(platform)

# legal message
message(
    "\nThis script will build third party components licensed under various open source licenses into your container images. The terms under which those components may be used and distributed can be found with the license document that is provided with those components. Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.\n\n"
    "-- Setting: BUILD_VERSION=${BUILD_VERSION}\n"
    "-- Setting: BUILD_MP3LAME=${BUILD_MP3LAME}\n"
    "-- Setting: BUILD_FDKAAC=${BUILD_FDKAAC}\n"
    "-- Setting: DOCKER_PREFIX=${DOCKER_PREFIX}\n"
)
