cmake_minimum_required(VERSION 3.20)
project(VisualBasicCompiler CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/compiler")

FLEX_TARGET(Lexer
    ${CMAKE_CURRENT_SOURCE_DIR}/compiler/lexer.l
    ${CMAKE_CURRENT_BINARY_DIR}/compiler/lexer.cpp
)

BISON_TARGET(Parser
    ${CMAKE_CURRENT_SOURCE_DIR}/compiler/parser.y
    ${CMAKE_CURRENT_BINARY_DIR}/compiler/parser.cpp
)

file(GLOB_RECURSE COMPILER_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/compiler/*.cpp"
)

add_executable(VisualBasicCompiler
    ${FLEX_Lexer_OUTPUTS}
    ${BISON_Parser_OUTPUTS}
    ${COMPILER_SOURCES}
)

target_include_directories(VisualBasicCompiler PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
)
