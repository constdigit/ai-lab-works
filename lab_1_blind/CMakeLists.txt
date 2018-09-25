cmake_minimum_required(VERSION 3.5)
project(blind_search)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_COMPILER g++-7)
set(CMAKE_CXX_STANDARD 17)

set(SOURCES board.cc search.cc main.cc)

add_executable(${PROJECT_NAME} ${SOURCES})
