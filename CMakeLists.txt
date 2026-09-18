cmake_minimum_required(VERSION 3.20)
project(VisualBasicCompiler CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX REQUIRED)

FLEX_TARGET(Lexer
    ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp
    COMPILE_FLAGS "--c++"
)

file(GLOB_RECURSE COMPILER_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/compiler/*.cpp"
)

add_executable(VisualBasicCompiler
    main.cpp
    ${FLEX_Lexer_OUTPUTS}
    ${COMPILER_SOURCES}
)

target_include_directories(VisualBasicCompiler PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)
