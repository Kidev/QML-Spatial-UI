set(SPATIALUI_QML SpatialItem.qml)

qt_policy(SET QTP0001 NEW)

qt_add_library(SpatialUILib STATIC)

set_target_properties(SpatialUILib PROPERTIES AUTOMOC ON)
target_link_libraries(
    SpatialUILib
    PUBLIC Qt6::Core
           Qt6::Gui
           Qt6::Quick
           Qt6::Quick3D
           Qt6::Qml
)
target_include_directories(SpatialUILib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(SpatialUILib PUBLIC -Wall -Werror -Wpedantic)

if (EMSCRIPTEN)
    target_compile_options(SpatialUILib PUBLIC -Os -DNDEBUG)
endif ()

qt_add_qml_module(
    SpatialUILib
    URI SpatialUI
    QML_FILES ${SPATIALUI_QML}
    IMPORTS QtQuick3D
    RESOURCE_PREFIX ""
)
