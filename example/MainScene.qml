import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Shapes
import SpatialUI

Window {
    id: root

    height: 480
    title: "SpatialUI Example"
    visible: true
    width: 640

    View3D {
        id: view3D

        anchors.fill: parent
        camera: perspectiveCamera

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.SkyBox

            lightProbe: Texture {
                textureData: ProceduralSkyTextureData {
                }
            }
        }

        AxisHelper {
            enableAxisLines: false
            enableXYGrid: false
            enableXZGrid: true
            enableYZGrid: false
            gridColor: "#ffffff"
            gridOpacity: 1
            scale: Qt.vector3d(5, 1, 5)
        }

        Node {
            id: originNode

            eulerRotation: Qt.vector3d(0, 0, 0)

            PropertyAnimation on eulerRotation.x {
                duration: 100
                from: 0
                loops: 1
                to: -10
            }
            PropertyAnimation on eulerRotation.y {
                duration: 100
                from: 0
                loops: 1
                to: -45
            }

            PerspectiveCamera {
                id: perspectiveCamera

                clipFar: 100000
                fieldOfView: 45
                position: Qt.vector3d(0, 0, 2000)
            }
        }

        OrbitCameraControllerCustom {
            id: orbitCameraController

            anchors.fill: parent
            buttonsToPan: Qt.RightButton
            camera: perspectiveCamera
            modifiersToPan: Qt.NoModifier
            mouseEnabled: !spatialUI.dragging
            origin: originNode
            panEnabled: true
        }

        Model {
            id: targetModel

            position: Qt.vector3d(0, 50, 0)
            source: "#Cube"

            materials: [
                DefaultMaterial {
                    diffuseColor: "green"
                }
            ]
        }

        Model {
            id: raycastPlane

            eulerRotation.x: -90
            objectName: "raycastPlane"
            pickable: true
            position: Qt.vector3d(0, -1, 0)
            scale: Qt.vector3d(1000, 1000, 1)
            source: "#Rectangle"

            materials: [
                DefaultMaterial {
                    diffuseColor: "grey"
                }
            ]
        }

        Human {
            id: targetHuman

            eulerRotation: Qt.vector3d(0, 0, 0)
            pivot: Qt.vector3d(-20, 0, 0)
            position: Qt.vector3d(100, 0, 0)
            scale: Qt.vector3d(20, 20, 20)

            RotationAnimation on eulerRotation.y {
                direction: RotationAnimation.Counterclockwise
                duration: 10000
                from: 360
                loops: Animation.Infinite
                to: 0
            }

            Component.onCompleted: () => eulerRotation.y = 360
        }

        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -70
        }

        SpatialItem {
            id: spatialUI

            property string altText: ""
            property bool dragging: false
            property vector3d initialTargetPosition
            property vector2d lastPos
            property vector2d offsetFactors

            function drag(x: real, y: real) {
                if (spatialUI.dragging) {
                    spatialUI.mouseArea.cursorShape = Qt.DragMoveCursor;
                    const currentPos = Qt.vector2d(x, y);
                    const adjustedMousePosition = currentPos.plus(spatialUI.lastPos.minus(spatialUI.linkerEnd)).minus(spatialUI.sizeScaled.times(spatialUI.offsetFactors));
                    const pickResults = view3D.pickAll(adjustedMousePosition.x, adjustedMousePosition.y);
                    for (var i = 0; i < pickResults.length; i++) {
                        let pickResult = pickResults[i];
                        if (pickResult.objectHit.objectName === "raycastPlane") {
                            spatialUI.lastPos = adjustedMousePosition;
                            spatialUI.altText = `${+(pickResult.scenePosition.x).toFixed(1)}`.padStart(7) + ' ; ' + `${+(pickResult.scenePosition.z).toFixed(1)}`.padEnd(7);
                            spatialUI.target.position = Qt.vector3d(pickResult.scenePosition.x, spatialUI.initialTargetPosition.y, pickResult.scenePosition.z);
                            break;
                        }
                    }
                }
            }

            function endDrag() {
                spatialUI.dragging = false;
                spatialUI.altText = "";
                if (spatialUI.mouseArea.containsMouse) {
                    spatialUI.mouseArea.cursorShape = Qt.OpenHandCursor;
                } else {
                    spatialUI.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }

            function startDrag(pos: vector2d) {
                spatialUI.lastPos = pos.minus(spatialUI.linkerEnd.minus(spatialUI.linkerStart)).minus(spatialUI.sizeScaled.times(spatialUI.offsetFactors));
                spatialUI.initialTargetPosition = spatialUI.target.position;
                spatialUI.dragging = true;
                spatialUI.mouseArea.cursorShape = Qt.ClosedHandCursor;
                spatialUI.drag(pos.x, pos.y);
            }

            camera: perspectiveCamera
            closeUpScaling: true
            depthTest: true
            fixedSize: spatialUI.hovered || spatialUI.dragging
            forceTopStacking: spatialUI.hovered || spatialUI.dragging
            hoverEnabled: true
            mouseEnabled: true
            offsetLinkEnd: Qt.vector3d(0, 250, 50)
            offsetLinkStart: Qt.vector3d(0, 0, 0)
            showLinker: true
            size: Qt.size(100, 50)
            target: targetModel

            linker: ShapePath {
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.BevelJoin
                startX: spatialUI.linkerStart.x
                startY: spatialUI.linkerStart.y
                strokeColor: spatialUI.hovered || spatialUI.dragging ? "black" : "white"
                strokeWidth: 4 * spatialUI.scaleFactor

                PathLine {
                    x: spatialUI.linkerEnd.x
                    y: spatialUI.linkerEnd.y
                }
            }

            onEntered: () => {
                if (!spatialUI.dragging) {
                    spatialUI.mouseArea.cursorShape = Qt.OpenHandCursor;
                }
            }
            onExited: () => {
                if (!spatialUI.dragging) {
                    spatialUI.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }
            onPositionChanged: mouse => spatialUI.drag(mouse.x + spatialUI.contentItem.x, mouse.y + spatialUI.contentItem.y)
            onPressed: mouse => {
                const pos = Qt.vector2d(mouse.x + spatialUI.contentItem.x, mouse.y + spatialUI.contentItem.y);
                spatialUI.offsetFactors = (Qt.vector2d(mouse.x, mouse.y).minus(Qt.vector2d(spatialUI.sizeScaled.x / 2, spatialUI.sizeScaled.y / 2))).times(Qt.vector2d(1 / spatialUI.sizeScaled.x, 1 / spatialUI.sizeScaled.y));
                spatialUI.startDrag(pos);
            }
            onReleased: () => spatialUI.endDrag()

            Rectangle {
                anchors.fill: parent
                border.color: spatialUI.hovered || spatialUI.dragging ? "white" : "black"
                border.width: spatialUI.hovered || spatialUI.dragging ? 4 : 2
                color: spatialUI.dragging || spatialUI.dragging ? "white" : (spatialUI.hovered || spatialUI.dragging ? "black" : "white")
                radius: 10

                Text {
                    anchors.centerIn: parent
                    color: spatialUI.hovered || spatialUI.dragging ? "white" : "black"
                    font.pixelSize: 16 * spatialUI.scaleFactor
                    text: "SpatialUI"
                    visible: !spatialUI.dragging
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3 * spatialUI.scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: spatialUI.hovered || spatialUI.dragging ? "white" : "black"
                    enabled: !spatialUI.dragging
                    font.pixelSize: 8 * spatialUI.scaleFactor
                    text: !spatialUI.dragging ? "Click and hold to move" : ""
                    visible: !spatialUI.dragging
                }

                Image {
                    id: moveIcon

                    anchors.centerIn: parent
                    height: 20 * spatialUI.scaleFactor
                    source: "img/move.png"
                    visible: spatialUI.dragging
                    width: 20 * spatialUI.scaleFactor
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    enabled: spatialUI.dragging
                    font.pixelSize: 8 * spatialUI.scaleFactor
                    text: spatialUI.dragging ? spatialUI.altText : ""
                    visible: spatialUI.dragging
                }
            }
        }

        SpatialItem {
            id: spatialNameTag

            property bool textClicked: false

            camera: perspectiveCamera
            closeUpScaling: true
            depthTest: true
            fixedSize: false
            hoverEnabled: true
            mouseEnabled: true
            offsetLinkEnd: Qt.vector3d(0, 300, 50)
            offsetLinkStart: Qt.vector3d(0, 125, 0)
            showLinker: true
            size: Qt.size(200, 50)
            stackingOrderLinker: 1
            target: targetHuman

            linker: ShapePath {
                capStyle: ShapePath.FlatCap
                fillColor: "white"
                joinStyle: ShapePath.BevelJoin
                //pathHints: ShapePath.PathConvex | ShapePath.PathLinear | ShapePath.PathNonIntersecting
                startX: spatialNameTag.linkerEnd.x
                startY: spatialNameTag.linkerEnd.y - uiRectangle.border.width + (uiRectangle.height / 2) - 1
                strokeColor: spatialNameTag.hovered ? "black" : "white"
                strokeWidth: 1 * spatialNameTag.scaleFactor

                PathLine {
                    x: spatialNameTag.linkerStart.x
                    y: spatialNameTag.linkerStart.y
                }

                PathLine {
                    x: spatialNameTag.linkerEnd.x + 20 * spatialNameTag.scaleFactor
                    y: spatialNameTag.linkerEnd.y - uiRectangle.border.width + (uiRectangle.height / 2) - 1
                }
            }

            onClicked: () => spatialNameTag.textClicked = !spatialNameTag.textClicked
            onEntered: () => spatialNameTag.mouseArea.cursorShape = Qt.PointingHandCursor
            onExited: () => spatialNameTag.mouseArea.cursorShape = Qt.ArrowCursor

            Rectangle {
                id: uiRectangle

                anchors.fill: parent
                border.color: spatialNameTag.hovered ? "black" : "white"
                border.width: 2
                color: "white"
                radius: 25

                Text {
                    anchors.centerIn: parent
                    color: "black"
                    font.pixelSize: 15.0 * spatialNameTag.scaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    text: !spatialNameTag.textClicked ? "You spin me right 'round\nbaby, right 'round\n" : "Like a record, baby\nright 'round, 'round, 'round"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        MouseArea {
            id: totalMouseArea

            anchors.fill: parent
            enabled: true
            hoverEnabled: true
            propagateComposedEvents: true

            onPositionChanged: mouse => {
                if (spatialUI.dragging) {
                    spatialUI.drag(mouse.x, mouse.y);
                    mouse.accepted = true;
                }
            }
            onReleased: mouse => {
                if (spatialUI.dragging) {
                    spatialUI.endDrag();
                }
            }
        }
    }

    Image {
        id: githubLogo

        anchors.margins: 10
        anchors.right: parent.right
        anchors.top: parent.top
        height: 32
        source: "img/github.png"
        width: 32
        z: 10

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                Qt.openUrlExternally("https://github.com/Kidev/QML-Spatial-UI");
            }
        }
    }

    Image {
        id: kidevLogo

        anchors.margins: 10
        anchors.right: githubLogo.left
        anchors.top: parent.top
        height: 32
        source: "img/logo.png"
        sourceSize: Qt.size(32, 32)
        width: 32
        z: 10

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                Qt.openUrlExternally("https://www.kidev.org");
            }
        }
    }
}
