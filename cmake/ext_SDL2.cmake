set(SDL2_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install/sdl2" CACHE PATH "Path to a directory where SDL2 library in going to be installed")

set(SDL2_LIBRARY_DIR ${SDL2_CMAKE_INSTALL_PREFIX}/lib)
set(SDL2_INCLUDE_DIR ${SDL2_CMAKE_INSTALL_PREFIX}/include)
set(SDL2_LIBNAME "SDL2")
set(SDL2MAIN_LIBNAME "SDL2main")

# generator expression won't work here
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(SDL2_LIBNAME "SDL2d")
    set(SDL2MAIN_LIBNAME "SDL2maind")
endif()

set(SDL2_LIBPATH "${SDL2_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}${SDL2_LIBNAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(SDL2MAIN_LIBPATH "${SDL2_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}${SDL2MAIN_LIBNAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

list(APPEND SDL2_EXT_CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_INSTALL_PREFIX:PATH=${SDL2_CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DSDL_FORCE_STATIC_VCRT=ON
    -DSDL_SHARED_ENABLED_BY_DEFAULT=OFF
    -DSDL_AUDIO_ENABLED_BY_DEFAULT=OFF
    -DSDL_STATIC_ENABLED_BY_DEFAULT=ON
    -DSDL_LIBC=ON
    -DSDL_HIDAPI_DISABLED=ON
)

ExternalProject_Add(
    ex_sdl2
    URL "${CMAKE_SOURCE_DIR}/engine/third_party/SDL2-2.0.22.zip"
    PREFIX "${CMAKE_BINARY_DIR}/ext/sdl2"
    CMAKE_ARGS ${SDL2_EXT_CMAKE_ARGS}
    BUILD_BYPRODUCTS ${SDL2_LIBPATH} ${SDL2MAIN_LIBPATH}
)

# work-around problem with INTERFACE_INCLUDE_DIRECTORIES
# and externalproject_add (https://gitlab.kitware.com/cmake/cmake/-/issues/15052)
file(MAKE_DIRECTORY ${SDL2_INCLUDE_DIR})
add_library(sdl2 STATIC IMPORTED)
add_dependencies(sdl2 ex_sdl2)
set_target_properties(sdl2 PROPERTIES
    IMPORTED_LOCATION ${SDL2_LIBPATH}
    INTERFACE_INCLUDE_DIRECTORIES ${SDL2_INCLUDE_DIR}
)

add_library(sdl2main STATIC IMPORTED)
add_dependencies(sdl2main ex_sdl2)
set_target_properties(sdl2main PROPERTIES
    IMPORTED_LOCATION ${SDL2MAIN_LIBPATH}
    INTERFACE_INCLUDE_DIRECTORIES ${SDL2_INCLUDE_DIR}
)

add_library(sdl2::sdl2 ALIAS sdl2)
add_library(sdl2::main ALIAS sdl2main)
