import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    required property PerspectiveCamera camera
    property bool closeUpScaling: false
    readonly property alias contentItem: contentItem
    default property alias data: contentItem.data
    property bool depthTest: false
    property real distanceFactor: 1.0
    property bool fixedSize: false
    property bool forceTopStacking: false
    property bool hoverEnabled: false
    property bool hovered: false
    property alias linker: linkerShape.data
    readonly property vector2d linkerEnd: Qt.vector2d(root.targetLinkEndOffset.x + (root.size.width * root.scaleFactor / 2), root.targetLinkEndOffset.y + (root.size.height * root.scaleFactor / 2))
    readonly property vector2d linkerStart: Qt.vector2d(root.targetLinkStartOffset.x, root.targetLinkStartOffset.y)
    property alias mouseArea: itemMouseArea
    property bool mouseEnabled: false
    property vector3d offsetLinkEnd: Qt.vector3d(0, 0, 0)
    property vector3d offsetLinkStart: Qt.vector3d(0, 0, 0)
    readonly property real scaleFactor: root.distanceFactor
    property bool showLinker: false
    required property size size
    readonly property vector2d sizeScaled: Qt.vector2d(root.size.width, root.size.height).times(root.scaleFactor)
    property int stackingOrder: 0
    property int stackingOrderLinker: -1
    required property Node target
    property vector2d targetLinkEndOffset
    property vector2d targetLinkStartOffset
    property vector2d targetOnScreen
    property int zDistance: 0
    readonly property int zOffset: 1000000000

    signal canceled
    signal clicked(var mouse)
    signal doubleClicked(var mouse)
    signal entered
    signal exited
    signal positionChanged(var mouse)
    signal pressAndHold(var mouse)
    signal pressed(var mouse)
    signal released(var mouse)
    signal wheel(var wheel)

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

    z: {
        if (root.forceTopStacking) {
            return root.zOffset + 1;
        }
        if (root.depthTest) {
            return root.zDistance;
        }
        return root.stackingOrder;
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
        function onActiveChanged() {
            root.updateSceneProjection();
        }

        function onHeightChanged() {
            root.updateSceneProjection();
        }

        function onWidthChanged() {
            root.updateSceneProjection();
        }

        target: root.Window.window
    }

    Connections {
        function onActiveChanged() {
            root.updateSceneProjection();
        }

        function onHeightChanged() {
            root.updateSceneProjection();
        }

        function onWidthChanged() {
            root.updateSceneProjection();
        }

        target: Window.window
    }

    Item {
        id: contentItemContainer

        x: root.targetLinkEndOffset.x + root.sizeScaled.x / 2
        y: root.targetLinkEndOffset.y + root.sizeScaled.y / 2

        Item {
            id: contentItem

            readonly property alias relativeX: contentItemContainer.x
            readonly property alias relativeY: contentItemContainer.y

            anchors.centerIn: parent
            height: root.size.height
            width: root.size.width

            transform: Scale {
                origin.x: contentItem.width / 2
                origin.y: contentItem.height / 2
                xScale: root.scaleFactor
                yScale: root.scaleFactor
            }

            MouseArea {
                id: itemMouseArea

                anchors.fill: contentItem
                enabled: root.mouseEnabled
                hoverEnabled: root.hoverEnabled
                propagateComposedEvents: true
                z: root.z + 1

                onCanceled: () => root.canceled()
                onClicked: mouse => root.clicked(mouse)
                onDoubleClicked: mouse => root.doubleClicked(mouse)
                onEntered: () => {
                    root.hovered = true;
                    root.entered();
                }
                onExited: () => {
                    root.hovered = false;
                    root.exited();
                }
                onPositionChanged: mouse => {
                    root.positionChanged(mouse);
                }
                onPressAndHold: mouse => root.pressAndHold(mouse)
                onPressed: mouse => root.pressed(mouse)
                onReleased: mouse => root.released(mouse)
                onWheel: wheel => {
                    root.wheel(wheel);
                    wheel.accepted = false;
                }
            }
        }
    }

    Shape {
        id: linkerShape

        visible: root.showLinker
        z: root.stackingOrderLinker
    }
}
