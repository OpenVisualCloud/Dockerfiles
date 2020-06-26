set(image "vcaca_setup_scripts")
add_custom_target(build_${image} ALL "${CMAKE_CURRENT_SOURCE_DIR}/build.sh" ${BUILD_VERSION})
add_dependencies(update_dockerfile build_${image})

