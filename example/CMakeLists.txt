
set(EXAMPLE_SOURCES
    main.cpp
)

set(EXAMPLE_QML
    MainScene.qml
)

qt_policy(SET QTP0001 NEW)

qt_add_executable(exampleExec
    ${EXAMPLE_SOURCES}
)

if (DEBUG)
    qt_add_qml_module(exampleExec
        URI example
        QML_FILES
            ${EXAMPLE_QML}
        NO_CACHEGEN
        NO_LINT
    )
else ()
    qt_add_qml_module(exampleExec
        URI example
        QML_FILES
            ${EXAMPLE_QML}
    )
endif ()

target_compile_options(exampleExec
    PUBLIC -Wall -Werror -Wpedantic)

set_target_properties(exampleExec PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER org.kidev.spatialui
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(exampleExec
    PRIVATE Qt6::Core Qt6::Gui Qt6::Quick Qt6::Quick3D Qt6::Qml
    PUBLIC SpatialUILibplugin)

install(TARGETS exampleExec
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
