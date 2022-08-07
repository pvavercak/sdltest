# thanks to
# https://gist.github.com/amir-saniyan/4339e6f3ef109c75eda8018f7d5192a7

function(build_external_project target file_name)
    set(CMAKELIST_CONTENT "
        cmake_minimum_required(VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION})

        project(build_external_project)

        file(MD5 \"${file_name}\" FILE_HASH)

        # CMAKE_OSX_ARCHITECTURES can contain semicolons.
        # Semicolons are problematic when passed to externalproject_add
        string(REPLACE \";\" \"$<SEMICOLON>\" CMAKE_OSX_ARCHITECTURES_ \"${CMAKE_OSX_ARCHITECTURES}\")

        include(ExternalProject)
        ExternalProject_add(${target}
            URL \"${file_name}\"
            URL_MD5 \${FILE_HASH}
            CMAKE_GENERATOR \"${CMAKE_GENERATOR}\"
            CMAKE_GENERATOR_PLATFORM \"${CMAKE_GENERATOR_PLATFORM}\"
            CMAKE_GENERATOR_TOOLSET \"${CMAKE_GENERATOR_TOOLSET}\"
            CMAKE_GENERATOR_INSTANCE \"${CMAKE_GENERATOR_INSTANCE}\"
            CMAKE_ARGS ${ARGN} \"-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES_}\")

        add_custom_target(build_external_project)
        add_dependencies(build_external_project ${target})
    ")

    set(TARGET_DIR "${CMAKE_CURRENT_BINARY_DIR}/ExternalProjects/${target}")

    file(WRITE "${TARGET_DIR}/CMakeLists.txt" "${CMAKELIST_CONTENT}")

    file(MAKE_DIRECTORY "${TARGET_DIR}" "${TARGET_DIR}/build")

    execute_process(COMMAND ${CMAKE_COMMAND}
        -G "${CMAKE_GENERATOR}"
        -A "${CMAKE_GENERATOR_PLATFORM}"
        -T "${CMAKE_GENERATOR_TOOLSET}"
        ..
        WORKING_DIRECTORY "${TARGET_DIR}/build")

    execute_process(COMMAND ${CMAKE_COMMAND}
        --build .
        --config ${CMAKE_BUILD_TYPE}
        WORKING_DIRECTORY "${TARGET_DIR}/build")
endfunction()
