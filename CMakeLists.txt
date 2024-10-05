cmake_minimum_required(VERSION 3.20)
project(
    projectSpatialUI
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(DEBUG "Set debug mode, disable QML compilation" OFF)
option(BUILD_EXAMPLE "Build the example application" ON)

find_package(
    Qt6 REQUIRED
    COMPONENTS Core
               Gui
               Quick
               Quick3D
               Qml
               QuickControls2
)

qt_standard_project_setup()

add_subdirectory(SpatialUI)
if (BUILD_EXAMPLE)
    add_subdirectory(example)
endif ()
