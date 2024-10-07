set(EXAMPLE_SOURCES main.cpp)
set(EXAMPLE_QML MainScene.qml Human.qml OrbitCameraControllerCustom.qml)
set(
    EXAMPLE_RESOURCES
    meshes/human.mesh
    img/move.png
    img/favicon.ico
    img/logo.png
    img/github.png
)

qt_add_executable(exampleExec ${EXAMPLE_SOURCES})

if (DEBUG)
    qt_add_qml_module(
        exampleExec
        URI example
        QML_FILES ${EXAMPLE_QML}
        NO_CACHEGEN NO_LINT
        RESOURCES ${EXAMPLE_RESOURCES}
        NO_RESOURCE_TARGET_PATH
    )
else ()
    qt_add_qml_module(
        exampleExec
        URI example
        QML_FILES ${EXAMPLE_QML}
        RESOURCES ${EXAMPLE_RESOURCES}
        NO_RESOURCE_TARGET_PATH
    )
endif ()

target_compile_options(
    exampleExec
    PUBLIC -Wall
           -Werror
           -Wpedantic
           -Os
           -DNDEBUG
)

if (EMSCRIPTEN)
    target_compile_options(exampleExec PUBLIC -Os -DNDEBUG)
endif ()

set_target_properties(
    exampleExec
    PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER org.kidev.spatialui
               MACOSX_BUNDLE TRUE
               WIN32_EXECUTABLE TRUE
)

target_link_libraries(
    exampleExec
    PRIVATE Qt6::Core
            Qt6::Gui
            Qt6::Quick
            Qt6::Quick3D
            Qt6::Qml
    PUBLIC SpatialUILibplugin
)

install(
    TARGETS exampleExec
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET exampleExec
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
