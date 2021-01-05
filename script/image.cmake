add_custom_target(build_${image} ALL "${CMAKE_CURRENT_SOURCE_DIR}/build.sh" ${BUILD_VERSION} ${OS_NAME} ${OS_VERSION} ${BUILD_FDKAAC} ${DOCKER_PREFIX})
if(dep_image)
    add_dependencies(build_${image} build_${dep_image})
endif()
add_custom_target(shell_${image} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh" ${DOCKER_PREFIX})

add_custom_target(update_${image}_dockerfile COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/build.sh" -n ${OS_NAME} ${OS_VERSION} ${BUILD_FDKAAC} ${DOCKER_PREFIX})
add_dependencies(update_dockerfile update_${image}_dockerfile)

add_custom_target(generate_${image}_readme COMMAND "${CMAKE_SOURCE_DIR}/script/generate_readme.py" "${CMAKE_CURRENT_SOURCE_DIR}")
add_dependencies(generate_readme generate_${image}_readme)

add_custom_target(upload_${image}_readme COMMAND "${CMAKE_SOURCE_DIR}/script/upload-dockerhub-readme.sh" ${DOCKER_PREFIX} "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
add_dependencies(upload_readme upload_${image}_readme)
