import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    property real baseDistance: 1.0
    required property PerspectiveCamera camera
    default property alias data: contentItem.data
    property real distanceFactor: 1.0
    property bool fixedSize: false
    property bool hoverEnabled: false
    property bool hovered: false
    property alias linker: linkerShape.data
    readonly property vector2d linkerEnd: Qt.vector2d(root.screenPositionOffset.x + (root.size.width / 2) * root.scaleFactor, root.screenPositionOffset.y + (root.size.height / 2) * root.scaleFactor)
    readonly property vector2d linkerStart: Qt.vector2d(root.screenPosition.x, root.screenPosition.y)
    property bool mouseEnabled: false
    property vector3d offset: Qt.vector3d(0, 0, 0)
    readonly property real scaleFactor: root.fixedSize ? 1.0 : root.distanceFactor
    property vector2d screenPosition: Qt.vector2d(-10000, -10000)
    property vector2d screenPositionOffset: Qt.vector2d(-10000, -10000)
    property bool showLinker: false
    required property size size
    required property Model target
    property vector3d windowPos: Qt.vector3d(-1, -1, -1)
    property vector3d windowPosOffset: Qt.vector3d(-1, -1, -1)
    readonly property int zOffsetItem: 11
    readonly property int zOffsetLinker: 10

    signal clicked(MouseEvent event)
    signal entered
    signal exited

    function updateDistanceFactor() {
        const distance = root.camera.position.minus(target.position).length();
        const fov = root.camera.fieldOfView * Math.PI / 180.0;
        const perspectiveScale = (root.baseDistance / distance) * (1 / Math.tan(fov / 2));
        root.distanceFactor = perspectiveScale;
    }

    function updateTargetPos() {
        root.windowPos = root.camera.mapToViewport(root.target.position);
        root.windowPosOffset = root.camera.mapToViewport(root.target.position.plus(root.offset));
        root.screenPosition = root.windowPos.z > 0 ? Qt.vector2d(root.windowPos.x * Window.width, root.windowPos.y * Window.height) : Qt.vector2d(-10000, -10000);
        root.screenPositionOffset = root.windowPosOffset.z > 0 ? Qt.vector2d(root.windowPosOffset.x * Window.width, root.windowPosOffset.y * Window.height) : Qt.vector2d(-10000, -10000);
        if (!root.fixedSize) {
            root.updateDistanceFactor();
        }
    }

    Component.onCompleted: {
        root.baseDistance = root.camera.position.minus(root.target.position).length();
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
        z: root.zOffsetItem

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
        z: root.zOffsetLinker
    }
}
