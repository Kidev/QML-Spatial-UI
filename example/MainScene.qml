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
                duration: 1000
                from: 0
                loops: 1
                to: -10
            }
            PropertyAnimation on eulerRotation.y {
                duration: 1000
                from: 0
                loops: 1
                to: -45
            }

            PerspectiveCamera {
                id: perspectiveCamera

                fieldOfView: 45
                position: Qt.vector3d(0, 0, 2000)
            }
        }

        OrbitCameraController {
            id: orbitCameraController

            anchors.fill: parent
            camera: perspectiveCamera
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
            property vector2d clickOffset: Qt.vector2d(0, 0)
            property bool dragging: false
            readonly property vector2d linkerOffset: spatialUI.linkerEnd.minus(spatialUI.linkerStart)

            function drag(mouse) {
                if (spatialUI.dragging) {
                    const shiftedMouse = Qt.vector2d(mouse.x, mouse.y).minus(spatialUI.linkerOffset).plus(spatialUI.clickOffset);
                    const pickResults = view3D.pickAll(shiftedMouse.x, shiftedMouse.y);
                    for (let i = 0; i < pickResults.length; i++) {
                        let pickResult = pickResults[i];
                        if (pickResult.objectHit.objectName === "raycastPlane") {
                            spatialUI.altText = `${+(pickResult.scenePosition.x).toFixed(1)};${+(pickResult.scenePosition.y).toFixed(1)}`;
                            spatialUI.target.position = Qt.vector3d(pickResult.scenePosition.x, 50, pickResult.scenePosition.z);
                            break;
                        }
                    }
                }
            }

            function endDrag() {
                dragging = false;
                spatialUI.altText = "";
            }

            function startDrag(mouse) {
                spatialUI.clickOffset = spatialUI.linkerEnd.minus(Qt.vector2d(mouse.x, mouse.y));
                dragging = true;
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
                pathHints: ShapePath.PathLinear
                startX: spatialUI.linkerStart.x
                startY: spatialUI.linkerStart.y
                strokeColor: spatialUI.hovered || spatialUI.dragging ? "black" : "white"
                strokeWidth: 4 * spatialUI.scaleFactor

                PathLine {
                    x: spatialUI.linkerEnd.x
                    y: spatialUI.linkerEnd.y
                }
            }

            onPositionChanged: mouse => drag(mouse)
            onPressed: mouse => startDrag(mouse)
            onReleased: mouse => endDrag()

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
                    text: !spatialUI.dragging ? "Hold to move" : ""
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
                pathHints: ShapePath.PathConvex | ShapePath.PathLinear | ShapePath.PathNonIntersecting
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
            anchors.fill: parent
            enabled: true
            hoverEnabled: true
            propagateComposedEvents: true

            onPositionChanged: mouse => {
                if (spatialUI.dragging) {
                    spatialUI.drag(mouse);
                    mouse.accepted = true;
                } else {
                    mouse.accepted = false;
                }
            }
            onReleased: mouse => {
                if (spatialUI.dragging) {
                    spatialUI.endDrag();
                }
                mouse.accepted = false;
            }
        }
    }
}
