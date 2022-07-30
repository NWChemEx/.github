cmake_minimum_required(VERSION 3.12)
file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/version.txt" VERSION)
project(DeveloperTools VERSION "${VERSION}" LANGUAGES NONE)

