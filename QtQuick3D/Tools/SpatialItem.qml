import QtQuick
import QtQuick.Shapes
import QtQuick3D

Item {
    id: root

    readonly property var camera: root.view.camera
    property bool closeUpScaling: false
    readonly property alias contentItem: contentItem
    readonly property vector2d coords: root.screenTargetCenterTopOffseted.plus(root.offsetLinkEnd2D)
    property int cursor: Qt.ArrowCursor
    default property alias data: contentItem.data
    property bool depthTest: false
    readonly property real distance: root.camera ? root.camera.scenePosition.minus(root.target.scenePosition).length() : 0
    property vector2d dragStartScreenPos
    readonly property bool dragging: itemMouseArea.dragging
    property bool fixedSize: false
    property bool forceTopStacking: false
    property bool holdDragsTarget: false
    property bool hoverEnabled: false
    readonly property bool hovered: itemMouseArea.containsMouse
    property vector3d initialTargetPosition
    property alias linker: linkerShape.data
    readonly property vector2d linkerEnd: Qt.vector2d(root.x + root.width / 2, root.y + root.height / 2)
    readonly property vector2d linkerStart: root.screenTargetCenterBaseOffseted
    readonly property alias mouseArea: itemMouseArea
    property bool mouseEnabled: false
    property bool mouseLinkerEnabled: false
    property vector3d offsetLinkEnd: Qt.vector3d(0, 0, 0)
    property vector2d offsetLinkEnd2D: Qt.vector2d(0, 0)
    property vector3d offsetLinkStart: Qt.vector3d(0, 0, 0)
    property vector2d offsetLinkStart2D: Qt.vector2d(0, 0)
    readonly property real scaleFactor: {
        if (!root.camera) {
            return 1;
        }
        let distanceScale;
        if (root.camera.projectionMode === PerspectiveCamera.Perspective) {
            const fov = root.camera.fieldOfView * Math.PI / 180.0;
            distanceScale = (Window.height / root.distance) * (1 / Math.tan(fov / 2));
        } else {
            const viewHeight = root.camera.verticalMagnification * 2;
            distanceScale = Window.height / viewHeight;
        }
        if (root.fixedSize) {
            return root.closeUpScaling ? Math.max(1.0, distanceScale) : 1.0;
        }
        return distanceScale;
    }
    property vector2d screenInitialTargetCenterBase
    readonly property vector3d screenSize: Qt.vector3d(Window.width, Window.height, 1)
    property vector2d screenTargetCenterBase
    property vector2d screenTargetCenterBaseOffseted
    property vector2d screenTargetCenterTopOffseted
    property bool showDraggingLine: false
    property bool showLinker: false
    required property size size
    property int stackingOrder: 0
    property int stackingOrderLinker: -1
    required property Model target
    readonly property vector3d targetCenterBase: root.target.scenePosition.plus(Qt.vector3d((root.target.bounds.minimum.x + root.target.bounds.maximum.x) / 2, root.target.bounds.minimum.y, (root.target.bounds.minimum.z + root.target.bounds.maximum.z) / 2).times(root.target.scale))
    readonly property vector3d targetCenterBaseOffseted: root.targetCenterBase.plus(root.offsetLinkStart)
    readonly property vector3d targetCenterTop: root.target.scenePosition.plus(Qt.vector3d((root.target.bounds.minimum.x + root.target.bounds.maximum.x) / 2, root.target.bounds.maximum.y, (root.target.bounds.minimum.z + root.target.bounds.maximum.z) / 2).times(root.target.scale))
    readonly property vector3d targetCenterTopOffseted: root.targetCenterTop.plus(root.offsetLinkEnd)
    required property View3D view
    readonly property int zDistance: root.zOffset - Math.round(root.distance)
    readonly property int zOffset: 1000000000

    signal entered
    signal exited

    function updateUIPosition() {
        if (!root.view || !root.camera || !root.target) {
            return;
        }
        const screenTargetCenterBaseOffseted = root.camera.mapToViewport(root.targetCenterBaseOffseted).times(root.screenSize).plus(root.offsetLinkStart2D);
        const screenTargetCenterTopOffseted = root.camera.mapToViewport(root.targetCenterTopOffseted).times(root.screenSize).plus(root.offsetLinkEnd2D);
        root.screenTargetCenterBaseOffseted = screenTargetCenterBaseOffseted.z > 0 ? screenTargetCenterBaseOffseted.toVector2d() : Qt.vector2d(-10000, -10000);
        root.screenTargetCenterTopOffseted = screenTargetCenterTopOffseted.z > 0 ? screenTargetCenterTopOffseted.toVector2d() : Qt.vector2d(-10000, -10000);
        if (root.dragging) {
            const screenTargetCenterBase = root.camera.mapToViewport(root.targetCenterBase).times(root.screenSize);
            root.screenTargetCenterBase = screenTargetCenterBase.z > 0 ? screenTargetCenterBase.toVector2d() : Qt.vector2d(-10000, -10000);
            if (root.showDraggingLine) {
                const screenInitialTargetCenterBase = root.camera.mapToViewport(root.initialTargetPosition).times(root.screenSize);
                root.screenInitialTargetCenterBase = screenInitialTargetCenterBase.z > 0 ? screenInitialTargetCenterBase.toVector2d() : Qt.vector2d(-10000, -10000);
            }
        }
    }

    height: root.size.height
    width: root.size.width
    x: root.coords.x
    y: root.coords.y
    z: root.forceTopStacking ? root.zOffset + 1 : (root.depthTest ? root.zDistance : root.stackingOrder)

    transform: Scale {
        origin.x: root.size.width / 2
        origin.y: root.size.height / 2
        xScale: root.scaleFactor
        yScale: root.scaleFactor
    }

    Component.onCompleted: Qt.callLater(root.updateUIPosition)
    Window.onHeightChanged: Qt.callLater(root.updateUIPosition)
    Window.onWidthChanged: Qt.callLater(root.updateUIPosition)
    onHoveredChanged: {
        if (root.hovered) {
            root.entered();
        } else {
            root.exited();
        }
    }
    onOffsetLinkEnd2DChanged: Qt.callLater(root.updateUIPosition)
    onOffsetLinkEndChanged: Qt.callLater(root.updateUIPosition)
    onOffsetLinkStart2DChanged: Qt.callLater(root.updateUIPosition)
    onOffsetLinkStartChanged: Qt.callLater(root.updateUIPosition)

    Connections {
        function onScenePositionChanged() {
            Qt.callLater(root.updateUIPosition);
        }

        function onSceneRotationChanged() {
            Qt.callLater(root.updateUIPosition);
        }

        target: root.camera
    }

    Connections {
        function onScenePositionChanged() {
            Qt.callLater(root.updateUIPosition);
        }

        function onSceneRotationChanged() {
            Qt.callLater(root.updateUIPosition);
        }

        target: root.camera ? root.camera.parent : null
    }

    Connections {
        function onScenePositionChanged() {
            Qt.callLater(root.updateUIPosition);
        }

        target: root.target
    }

    Item {
        id: contentItem

        anchors.fill: root
    }

    MouseArea {
        id: itemMouseArea

        property bool dragging: false

        anchors.fill: root
        cursorShape: root.cursor
        enabled: root.mouseEnabled
        hoverEnabled: root.hoverEnabled

        onEntered: {
            if (root.holdDragsTarget) {
                itemMouseArea.cursorShape = Qt.OpenHandCursor;
            }
        }
        onExited: {
            if (root.holdDragsTarget) {
                itemMouseArea.cursorShape = Qt.ArrowCursor;
            }
        }
        onPositionChanged: mouse => {
            if (itemMouseArea.dragging) {
                root.mouseArea.cursorShape = Qt.DragMoveCursor;
                const currentPos = Qt.vector2d(mouse.x, mouse.y).times(root.scaleFactor).plus(Qt.vector2d(root.x, root.y));
                const pos = currentPos.minus(root.screenTargetCenterTopOffseted.plus(root.offsetLinkEnd2D).minus(root.screenTargetCenterBase)).minus(root.dragStartScreenPos.times(root.scaleFactor));
                const viewportX = pos.x / root.view.width;
                const viewportY = pos.y / root.view.height;
                const nearPoint = root.view.camera.mapFromViewport(Qt.vector3d(viewportX, viewportY, 0));
                const farPoint = root.view.camera.mapFromViewport(Qt.vector3d(viewportX, viewportY, 1));
                const ray_start = nearPoint;
                const ray_direction = farPoint.minus(nearPoint).normalized();
                const planeYPosition = 0;
                const plane_normal = Qt.vector3d(0, 1, 0);
                const plane_point = Qt.vector3d(0, planeYPosition, 0);
                const denominator = ray_direction.dotProduct(plane_normal);
                if (Math.abs(denominator) > 0.0001) {
                    const t = plane_point.minus(ray_start).dotProduct(plane_normal) / denominator;
                    if (t >= 0) {
                        const intersection = ray_start.plus(ray_direction.times(t));
                        root.target.position = Qt.vector3d(intersection.x, root.initialTargetPosition.y, intersection.z);
                    }
                }
            }
        }
        onPressed: mouse => {
            if (root.holdDragsTarget) {
                const pos = Qt.vector2d(mouse.x, mouse.y).times(root.scaleFactor).plus(Qt.vector2d(root.x, root.y));
                root.dragStartScreenPos = pos.minus(Qt.vector2d(root.x, root.y));
                root.initialTargetPosition = root.targetCenterBaseOffseted;
                itemMouseArea.dragging = true;
                root.mouseArea.cursorShape = Qt.ClosedHandCursor;
            }
            root.updateUIPosition();
        }
        onReleased: () => {
            itemMouseArea.dragging = false;
            if (root.holdDragsTarget) {
                root.initialTargetPosition = root.target.scenePosition;
                if (root.mouseArea.containsMouse) {
                    root.mouseArea.cursorShape = Qt.OpenHandCursor;
                } else {
                    root.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }
            root.updateUIPosition();
        }
    }

    Shape {
        id: linkerShape

        anchors.fill: parent
        parent: Window.contentItem
        z: root.z + root.stackingOrderLinker
    }

    Shape {
        id: draggingLineShape

        anchors.fill: parent
        parent: Window.contentItem
        visible: root.dragging && root.showDraggingLine

        ShapePath {
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.BevelJoin
            startX: root.screenInitialTargetCenterBase.x
            startY: root.screenInitialTargetCenterBase.y
            strokeColor: "green"
            strokeWidth: 3

            PathLine {
                x: root.screenTargetCenterBaseOffseted.x
                y: root.screenTargetCenterBaseOffseted.y
            }
        }
    }
}
