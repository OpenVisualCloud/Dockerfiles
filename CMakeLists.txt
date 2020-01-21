cmake_minimum_required (VERSION 2.8)

Project(DockerFiles NONE)

if (NOT DEFINED BUILD_MP3LAME)
    set(BUILD_MP3LAME "ON")
endif()

if (NOT DEFINED BUILD_FDKAAC)
    set(BUILD_FDKAAC "ON")
endif()

if (NOT DEFINED ONLY_DOCKERFILES)
    set(ONLY_DOCKERFILES "OFF")
endif()

if (NOT DEFINED DOCKER_PREFIX)
    set(DOCKER_PREFIX "openvisualcloud")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/script/")

enable_testing()

include(platform)

# legal message
message(
    "\nThis script will build third party components licensed under various open source licenses into your container images.\n"
    "The terms under which those components may be used and distributed can be found with the license document that is provided with those components.\n"
    "Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.\n"
    "\n-- Setting: BUILD_MP3LAME=${BUILD_MP3LAME}\n"
    "-- Setting: BUILD_FDKAAC=${BUILD_FDKAAC}\n"
    "-- Setting: ONLY_DOCKERFILES=${ONLY_DOCKERFILES}\n"
    "-- Setting: DOCKER_PREFIX=${DOCKER_PREFIX}\n")
