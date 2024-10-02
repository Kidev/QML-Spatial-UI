import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    required property PerspectiveCamera camera
    property bool closeUpScaling: false
    default property alias data: contentItem.data
    property bool depthTest: false
    property real distanceFactor: 1.0
    property bool fixedSize: false
    property bool hoverEnabled: false
    property bool hovered: false
    property alias linker: linkerShape.data
    property vector2d linkerEnd: Qt.vector2d(root.targetLinkEndOffset.x + (root.size.width / 2) * root.scaleFactor, root.targetLinkEndOffset.y + (root.size.height / 2) * root.scaleFactor)
    property vector2d linkerStart: Qt.vector2d(root.targetLinkStartOffset.x, root.targetLinkStartOffset.y)
    property bool mouseEnabled: false
    property vector3d offsetLinkEnd: Qt.vector3d(0, 0, 0)
    property vector3d offsetLinkStart: Qt.vector3d(0, 0, 0)
    property real scaleFactor: root.distanceFactor
    property bool showLinker: false
    required property size size
    required property Node target
    property vector2d targetLinkEndOffset: Qt.vector2d(-10000, -10000)
    property vector2d targetLinkStartOffset: Qt.vector2d(-10000, -10000)
    property vector2d targetOnScreen: Qt.vector2d(-10000, -10000)
    property int zDistance: 0
    property int zItemOffset: 11
    property int zLinkerOffset: 10
    property int zOffset: 1000000

    signal clicked(MouseEvent event)
    signal entered
    signal exited

    function updateDistanceFactor() {
        const distance = root.camera.scenePosition.minus(root.target.scenePosition).length();
        root.zDistance = root.zOffset - Math.round(distance);
        const fov = root.camera.fieldOfView * Math.PI / 180.0;
        let perspectiveScale = (Window.height / distance) * (1 / Math.tan(fov / 2));
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
        const screenSize = Qt.vector3d(Window.width, Window.height, 1);
        const targetOnScreen = root.camera.mapToViewport(root.target.scenePosition).times(screenSize);
        const targetLinkStartOffset = root.camera.mapToViewport(root.target.scenePosition.plus(root.offsetLinkStart)).times(screenSize);
        const targetLinkEndOffset = root.camera.mapToViewport(root.target.scenePosition.plus(root.offsetLinkEnd)).times(screenSize);
        root.targetOnScreen = targetOnScreen.z > 0 ? targetOnScreen.toVector2d() : Qt.vector2d(-10000, -10000);
        root.targetLinkStartOffset = targetLinkStartOffset.z > 0 ? targetLinkStartOffset.toVector2d() : Qt.vector2d(-10000, -10000);
        root.targetLinkEndOffset = targetLinkEndOffset.z > 0 ? targetLinkEndOffset.toVector2d() : Qt.vector2d(-10000, -10000);
        root.updateDistanceFactor();
    }

    Component.onCompleted: () => root.updateSceneProjection()
    onFixedSizeChanged: () => root.updateDistanceFactor()
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

    Connections {
        function onHeightChanged() {
            root.updateSceneProjection();
        }

        function onWidthChanged() {
            root.updateSceneProjection();
        }

        target: Window.window
    }

    Item {
        id: contentItem

        height: root.size.height * root.scaleFactor
        width: root.size.width * root.scaleFactor
        x: root.targetLinkEndOffset.x
        y: root.targetLinkEndOffset.y
        z: root.depthTest ? root.zDistance + root.zItemOffset : root.zItemOffset

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
        z: root.depthTest ? root.zDistance + root.zLinkerOffset : root.zLinkerOffset
    }
}
