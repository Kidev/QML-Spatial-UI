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

        OrbitCameraController {
            id: orbitCameraController

            anchors.fill: parent
            camera: perspectiveCamera
            mouseEnabled: !ui.dragging
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
            id: ui

            property string altText: ""
            property bool dragging: false
            //property vector2d lastPos
            //property vector2d offsetFactors
            property vector2d firstClickPos
            property vector3d initialTargetPosition

            function beginDrag(x, y) {
                ui.mouseArea.cursorShape = Qt.ClosedHandCursor;
                ui.initialTargetPosition = ui.target.position;
                ui.firstClickPos = Qt.vector2d(x, y);
                ui.dragging = true;
            }

            function drag(x, y) {
                if (dragging) {
                    const centerUI = ui.linkerEnd;
                    const clickPos = Qt.vector2d(x, y);
                    const toCenter = centerUI.minus(ui.firstClickPos);
                    const toBottomLeft = Qt.vector2d(-size.width / 2, size.height / 2).times(ui.scaleFactor);
                    const bottomLeft = clickPos.plus(toCenter).plus(toBottomLeft);
                    const bottomLeftToTargetPos = ui.targetOnScreen.minus(ui.targetLinkEndOffset);
                    const targetPosCorrected = bottomLeft.plus(bottomLeftToTargetPos);
                    const pickResults = view3D.pickAll(targetPosCorrected.x, targetPosCorrected.y);
                    for (let i = 0; i < pickResults.length; i++) {
                        const pickResult = pickResults[i];
                        if (pickResult.objectHit.objectName === "raycastPlane") {
                            ui.altText = `${+(pickResult.scenePosition.x).toFixed(1)}`.padStart(7) + ' ; ' + `${+(pickResult.scenePosition.z).toFixed(1)}`.padEnd(7);
                            ui.target.position = Qt.vector3d(pickResult.scenePosition.x, ui.initialTargetPosition.y, pickResult.scenePosition.z);
                            break;
                        }
                    }
                }
            }

            function endDrag() {
                ui.dragging = false;
                ui.altText = "";
                if (ui.mouseArea.containsMouse) {
                    ui.mouseArea.cursorShape = Qt.OpenHandCursor;
                } else {
                    ui.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }

            /*            function drag(x: real, y: real) {
                if (ui.dragging) {
                    ui.mouseArea.cursorShape = Qt.DragMoveCursor;
                    const currentPos = Qt.vector2d(x, y);
                    const adjustedMousePosition = currentPos.plus(ui.lastPos.minus(ui.linkerEnd)).minus(ui.sizeScaled.times(ui.offsetFactors));
                    const pickResults = view3D.pickAll(adjustedMousePosition.x, adjustedMousePosition.y);
                    for (var i = 0; i < pickResults.length; i++) {
                        let pickResult = pickResults[i];
                        if (pickResult.objectHit.objectName === "raycastPlane") {
                            ui.lastPos = adjustedMousePosition;
                            ui.altText = `${+(pickResult.scenePosition.x).toFixed(1)}`.padStart(7) + ' ; ' + `${+(pickResult.scenePosition.z).toFixed(1)}`.padEnd(7);
                            ui.target.position = Qt.vector3d(pickResult.scenePosition.x, ui.initialTargetPosition.y, pickResult.scenePosition.z);
                            break;
                        }
                    }
                }
            }

            function endDrag() {
                ui.dragging = false;
                ui.altText = "";
                if (ui.mouseArea.containsMouse) {
                    ui.mouseArea.cursorShape = Qt.OpenHandCursor;
                } else {
                    ui.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }

            function startDrag(pos: vector2d) {
                ui.lastPos = pos.minus(ui.linkerEnd.minus(ui.linkerStart)).minus(ui.sizeScaled.times(ui.offsetFactors));
                ui.initialTargetPosition = ui.target.position;
                ui.dragging = true;
                ui.mouseArea.cursorShape = Qt.ClosedHandCursor;
                ui.drag(pos.x, pos.y);
            }*/

            camera: perspectiveCamera
            closeUpScaling: true
            depthTest: true
            fixedSize: ui.hovered || ui.dragging
            forceTopStacking: ui.hovered || ui.dragging
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
                startX: ui.linkerStart.x
                startY: ui.linkerStart.y
                strokeColor: ui.hovered || ui.dragging ? "black" : "white"
                strokeWidth: 4 * ui.scaleFactor

                PathLine {
                    x: ui.linkerEnd.x
                    y: ui.linkerEnd.y
                }
            }

            onEntered: () => {
                if (!ui.dragging) {
                    ui.mouseArea.cursorShape = Qt.OpenHandCursor;
                }
            }
            onExited: () => {
                if (!ui.dragging) {
                    ui.mouseArea.cursorShape = Qt.ArrowCursor;
                }
            }
            onPositionChanged: mouse => ui.drag(mouse.x + ui.contentItem.x, mouse.y + ui.contentItem.y)
            onPressed: mouse => {
                //const pos = Qt.vector2d(mouse.x + ui.contentItem.x, mouse.y + ui.contentItem.y);
                //ui.offsetFactors = (Qt.vector2d(mouse.x, mouse.y).minus(Qt.vector2d(ui.sizeScaled.x / 2, ui.sizeScaled.y / 2))).times(Qt.vector2d(1 / ui.sizeScaled.x, 1 / ui.sizeScaled.y));
                //ui.startDrag(pos);
                ui.beginDrag(mouse.x + ui.contentItem.x, mouse.y + ui.contentItem.y);
            }
            onReleased: () => ui.endDrag()

            Rectangle {
                anchors.fill: parent
                border.color: ui.hovered || ui.dragging ? "white" : "black"
                border.width: ui.hovered || ui.dragging ? 4 : 2
                color: ui.dragging || ui.dragging ? "white" : (ui.hovered || ui.dragging ? "black" : "white")
                radius: 10

                Text {
                    anchors.centerIn: parent
                    color: ui.hovered || ui.dragging ? "white" : "black"
                    font.pixelSize: 16 * ui.scaleFactor
                    text: "ui"
                    visible: !ui.dragging
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3 * ui.scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ui.hovered || ui.dragging ? "white" : "black"
                    enabled: !ui.dragging
                    font.pixelSize: 8 * ui.scaleFactor
                    text: !ui.dragging ? "Click and hold to move" : ""
                    visible: !ui.dragging
                }

                Image {
                    id: moveIcon

                    anchors.centerIn: parent
                    height: 20 * ui.scaleFactor
                    source: "img/move.png"
                    visible: ui.dragging
                    width: 20 * ui.scaleFactor
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    enabled: ui.dragging
                    font.pixelSize: 8 * ui.scaleFactor
                    text: ui.dragging ? ui.altText : ""
                    visible: ui.dragging
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
                if (ui.dragging) {
                    ui.drag(mouse.x, mouse.y);
                    mouse.accepted = true;
                }
            }
            onReleased: mouse => {
                if (ui.dragging) {
                    ui.endDrag();
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
