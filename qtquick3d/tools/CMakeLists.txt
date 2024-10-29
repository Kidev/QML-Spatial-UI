qt_internal_add_qml_module(
    Quick3DTools
    URI "QtQuick3D.Tools"
    VERSION "${PROJECT_VERSION}"
    CLASS_NAME QtQuick3DToolsPlugin
    PLUGIN_TARGET qtquick3dtoolsplugin
    DEPENDENCIES QtQuick3D/auto
    PAST_MAJOR_VERSIONS 1
    QML_FILES SpatialItem.qml ExtendedOrbitCameraController.qml
    DEFINES QT_BUILD_QUICK3DTOOLS_LIB
    LIBRARIES Qt::Quick3D
    PUBLIC_LIBRARIES
        Qt::Qml
        Qt::Quick
        Qt::Quick3DPrivate
        Qt::GuiPrivate
)

_qt_internal_add_qml_static_plugin_dependency(Quick3DTools)
