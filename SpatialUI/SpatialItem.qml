import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    property real baseDistance: 1.0
    required property PerspectiveCamera camera
    property bool closeUpScaling: false
    default property alias data: contentItem.data
    property real distanceFactor: {
        if (!root.camera) {
            return 1.0;
        }
        const distance = root.camera.scenePosition.minus(target.scenePosition).length();
        const fov = root.camera.fieldOfView * Math.PI / 180.0;
        let perspectiveScale = (root.baseDistance / distance) * (1 / Math.tan(fov / 2));
        if (root.fixedSize) {
            if (root.closeUpScaling) {
                perspectiveScale = Math.max(1.0, perspectiveScale);
            } else {
                perspectiveScale = 1.0;
            }
        }
        return perspectiveScale;
    }
    property bool fixedSize: false
    property bool hoverEnabled: false
    property bool hovered: false
    property alias linker: linkerShape.data
    readonly property vector2d linkerEnd: Qt.vector2d(root.screenPositionOffset.x + (root.size.width / 2) * root.scaleFactor, root.screenPositionOffset.y + (root.size.height / 2) * root.scaleFactor)
    readonly property vector2d linkerStart: Qt.vector2d(root.screenPosition.x, root.screenPosition.y)
    property bool mouseEnabled: false
    property vector3d offset: Qt.vector3d(0, 0, 0)
    property vector3d offsetAnchor: Qt.vector3d(0, 0, 0)
    readonly property real scaleFactor: root.fixedSize && !root.closeUpScaling ? 1.0 : root.distanceFactor
    property vector2d screenPosition: root.camera && root.windowPos.z > 0 ? Qt.vector2d(root.windowPos.x * Window.width, root.windowPos.y * Window.height) : Qt.vector2d(-10000, -10000)
    property vector2d screenPositionOffset: root.camera && root.windowPosOffset.z > 0 ? Qt.vector2d(root.windowPosOffset.x * Window.width, root.windowPosOffset.y * Window.height) : Qt.vector2d(-10000, -10000)
    property bool showLinker: false
    required property size size
    required property Node target
    property vector3d windowPos: root.camera ? root.camera.mapToViewport(root.target.scenePosition.plus(root.offsetAnchor)) : Qt.vector3d(-1, -1, -1)
    property vector3d windowPosOffset: root.camera ? root.camera.mapToViewport(root.target.scenePosition.plus(root.offsetAnchor).plus(root.offset)) : Qt.vector3d(-1, -1, -1)
    property int zItem: 11
    property int zLinker: 10

    signal clicked(MouseEvent event)
    signal entered
    signal exited

    function updateTargetPos() {
    }

    Component.onCompleted: () => {
        root.baseDistance = root.camera.scenePosition.minus(root.target.scenePosition).length();
        root.updateTargetPos();
    }

    Connections {
        function onPositionChanged() {
            root.updateTargetPos();
        }

        function onRotationChanged() {
            root.updateTargetPos();
        }

        target: root.camera
    }

    Connections {
        function onPositionChanged() {
            root.updateTargetPos();
        }

        function onRotationChanged() {
            root.updateTargetPos();
        }

        target: root.camera.parent
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
