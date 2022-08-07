cmake_minimum_required(VERSION 3.15)
cmake_policy(VERSION 3.15)
cmake_policy(SET CMP0069 NEW)
cmake_policy(SET CMP0091 NEW)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
    message(STATUS "Build type not specified: Use Release by default")
endif(NOT CMAKE_BUILD_TYPE)

project(game_project VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(${CMAKE_SYSTEM_NAME} MATCHES Linux)
    set(PLATFORM_LINUX TRUE)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES Darwin)
    set(PLATFORM_MACOSX TRUE)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES Windows)
    set(PLATFORM_WINDOWS TRUE)
endif()

include(cmake/ext_SDL2.cmake)

if(MSVC)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib /SUBSYSTEM:Windows ")
endif(MSVC)

# Game
add_executable(game_project src/main.cpp)
target_include_directories(game_project PUBLIC engine engine/third_party engine/third_party/miniaudio)
set_target_properties(game_project PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
)

if(MSVC)
    target_link_libraries(game_project PRIVATE
        dinput8
        dxguid
        user32
        gdi32
        winmm
        wininet
        imm32
        ole32
        oleaut32
        wbemuuid
        advapi32
        shell32
        version
        uuid
        setupapi
        SDL2::SDL2-static
        SDL2::SDL2main)
else(MSVC)
    target_link_libraries(game_project PRIVATE
        SDL2::SDL2-static
        SDL2::SDL2main)
endif(MSVC)

add_custom_target(debug
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Debug ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all
    COMMENT "Creating the executable in debug mode.")

add_custom_target(release
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Release ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all
    COMMENT "Creating the executable in release mode.")
