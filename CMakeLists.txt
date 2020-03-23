cmake_minimum_required (VERSION 2.8)

Project(DockerFiles NONE)

if (NOT DEFINED BUILD_VERSION)
    set(BUILD_VERSION "1.0")
endif()

if (NOT DEFINED BUILD_MP3LAME)
    set(BUILD_MP3LAME "ON")
endif()

if (NOT DEFINED BUILD_FDKAAC)
    set(BUILD_FDKAAC "ON")
endif()

if (NOT DEFINED UPDATE_DOCKERFILES)
    set(UPDATE_DOCKERFILES "OFF")
endif()

if (NOT DEFINED DOCKER_PREFIX)
    set(DOCKER_PREFIX "openvisualcloud")
endif()

if (NOT DEFINED UPDATE_IMAGELIST)
    set(UPDATE_IMAGELIST "OFF")
endif()

if (NOT DEFINED UPDATE_DOCKERHUB_README)
    set(UPDATE_DOCKERHUB_README "OFF")
endif()

if (UPDATE_IMAGELIST STREQUAL "ON")
    set(UPDATE_DOCKERFILES "ON")
endif()

if (NOT DEFINED UPDATE_IMAGE_README)
    set(UPDATE_IMAGE_README "OFF")
endif()

if (UPDATE_IMAGE_README STREQUAL "ON")
    set(UPDATE_DOCKERFILES "ON")
endif()

if (UPDATE_DOCKERHUB_README STREQUAL "ON")
    set(UPDATE_DOCKERFILES "ON")
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
    "-- Setting: UPDATE_DOCKERFILES=${UPDATE_DOCKERFILES}\n"
    "-- Setting: UPDATE_IMAGELIST=${UPDATE_IMAGELIST}\n"
    "-- Setting: UPDATE_IMAGE_README=${UPDATE_IMAGE_README}\n"
    "-- Setting: UPDATE_DOCKERHUB_README=${UPDATE_DOCKERHUB_README}\n")

