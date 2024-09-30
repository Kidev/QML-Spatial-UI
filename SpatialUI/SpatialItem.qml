import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    property real baseDistance: 1.0
    required property PerspectiveCamera camera
    property bool closeUpScaling: false
    default property alias data: contentItem.data
    property real distanceFactor: 1.0
    property bool fixedSize: false
    property bool hoverEnabled: false
    property bool hovered: false
    property alias linker: linkerShape.data
    property vector2d linkerEnd: Qt.vector2d(root.screenPositionOffset.x + (root.size.width / 2) * root.scaleFactor, root.screenPositionOffset.y + (root.size.height / 2) * root.scaleFactor)
    property vector2d linkerStart: Qt.vector2d(root.screenPositionAnchorOffset.x, root.screenPositionAnchorOffset.y)
    property bool mouseEnabled: false
    property vector3d offset: Qt.vector3d(0, 0, 0)
    property vector3d offsetAnchor: Qt.vector3d(0, 0, 0)
    property real scaleFactor: root.fixedSize ? 1.0 : root.distanceFactor
    property vector2d screenPosition: Qt.vector2d(-10000, -10000)
    property vector2d screenPositionAnchorOffset: Qt.vector2d(-10000, -10000)
    property vector2d screenPositionOffset: Qt.vector2d(-10000, -10000)
    property bool showLinker: false
    required property size size
    required property Node target
    property vector3d windowPos: Qt.vector3d(-1, -1, -1)
    property vector3d windowPosAnchorOffset: Qt.vector3d(-1, -1, -1)
    property vector3d windowPosOffset: Qt.vector3d(-1, -1, -1)
    property int zItem: 11
    property int zLinker: 10

    signal clicked(MouseEvent event)
    signal entered
    signal exited

    function updateDistanceFactor() {
        const distance = root.camera.scenePosition.minus(root.target.scenePosition).length();
        const fov = root.camera.fieldOfView * Math.PI / 180.0;
        const perspectiveScale = (root.baseDistance / distance) * (1 / Math.tan(fov / 2));
        if (root.fixedSize) {
            if (root.closeUpScaling) {
                perspectiveScale = Math.max(1.0, perspectiveScale);
            } else {
                perspectiveScale = 1.0;
            }
        }
        root.distanceFactor = perspectiveScale;
    }

    function updateSceneProjection() {
        root.windowPos = root.camera.mapToViewport(root.target.scenePosition);
        root.windowPosOffset = root.camera.mapToViewport(root.target.scenePosition.plus(root.offset));
        root.windowPosAnchorOffset = root.camera.mapToViewport(root.target.scenePosition.plus(root.offsetAnchor));
        root.screenPosition = root.windowPos.z > 0 ? Qt.vector2d(root.windowPos.x * Window.width, root.windowPos.y * Window.height) : Qt.vector2d(-10000, -10000);
        root.screenPositionOffset = root.windowPosOffset.z > 0 ? Qt.vector2d(root.windowPosOffset.x * Window.width, root.windowPosOffset.y * Window.height) : Qt.vector2d(-10000, -10000);
        root.screenPositionAnchorOffset = root.windowPosAnchorOffset.z > 0 ? Qt.vector2d(root.windowPosAnchorOffset.x * Window.width, root.windowPosAnchorOffset.y * Window.height) : Qt.vector2d(-10000, -10000);
        if (!root.fixedSize) {
            root.updateDistanceFactor();
        }
    }

    Component.onCompleted: () => {
        root.baseDistance = root.camera.scenePosition.minus(root.target.scenePosition).length();
        root.updateSceneProjection();
    }
    onHoveredChanged: () => root.updateSceneProjection()

    Connections {
        function onScenePositionChanged() {
            root.updateSceneProjection();
        }

        function onSceneRotationChanged() {
            root.updateSceneProjection();
        }

        target: root.camera
    }

    Connections {
        function onScenePositionChanged() {
            root.updateSceneProjection();
        }

        function onSceneRotationChanged() {
            root.updateSceneProjection();
        }

        target: root.camera.parent
    }

    Connections {
        function onScenePositionChanged() {
            root.updateSceneProjection();
        }

        function onSceneRotationChanged() {
            root.updateSceneProjection();
        }

        target: root.target
    }

    Item {
        id: contentItem

        height: root.size.height * root.scaleFactor
        width: root.size.width * root.scaleFactor
        x: root.screenPositionOffset.x
        y: root.screenPositionOffset.y
        z: root.zItem

        MouseArea {
            anchors.fill: contentItem
            enabled: root.mouseEnabled
            hoverEnabled: root.hoverEnabled

            onClicked: event => root.clicked(event)
            onEntered: () => {
                root.hovered = true;
                root.entered();
            }
            onExited: () => {
                root.hovered = false;
                root.exited();
            }
        }
    }

    Shape {
        id: linkerShape

        visible: root.showLinker
        z: root.zLinker
    }
}
