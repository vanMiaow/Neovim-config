
# minimum version
cmake_minimum_required(VERSION 3.14)

# fortran compiler
set(CMAKE_Fortran_COMPILER "ifx")

# project name
project(_PROJECT_NAME_ VERSION _PROJECT_VERSION_ LANGUAGES Fortran)

# project root
set(PROJECT_ROOT  "${CMAKE_SOURCE_DIR}/..")

# target name
set(_TARGET_NAME_ "_EXECUTABLE_NAME_${CMAKE_BUILD_TYPE}")

# .exe path
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
# .mod path
set(CMAKE_Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/mod")

# compiler arguments
set(CMAKE_Fortran_FLAGS         "/nologo /fpp")
set(CMAKE_Fortran_FLAGS_DEBUG   "/Od /debug:full")
set(CMAKE_Fortran_FLAGS_RELEASE "/O2")

# source files
add_executable(
    ${_TARGET_NAME_}
    "${PROJECT_ROOT}/src/_SOURCE_NAME_"
)

# install path
install(TARGETS ${_TARGET_NAME_} DESTINATION "${PROJECT_ROOT}/bin")

