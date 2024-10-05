import QtQuick
import QtQuick3D
import QtQuick.Controls
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
            enableAxisLines: true
            enableXYGrid: false
            enableXZGrid: true
            enableYZGrid: false
            eulerRotation.y: 90
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
                    diffuseColor: "red"
                }
            ]
        }

        Model {
            id: raycastPlane

            eulerRotation.x: -90
            objectName: "raycastPlane"
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

            property bool dragging: false

            camera: perspectiveCamera
            closeUpScaling: true
            depthTest: true
            fixedSize: spatialUI.hovered
            forceTopStacking: spatialUI.hovered
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
                strokeColor: spatialUI.hovered ? "black" : "white"
                strokeWidth: 4 * spatialUI.scaleFactor

                PathLine {
                    x: spatialUI.linkerEnd.x
                    y: spatialUI.linkerEnd.y
                }
            }

            onPositionChanged: mouse => {
                if (spatialUI.dragging) {
                    let pickResults = view3D.pickAll(mouse.x, mouse.y);
                    for (let i = 0; i < pickResults.length; i++) {
                        let pickResult = pickResults[i];
                        if (pickResult.objectHit.objectName === "raycastPlane") {
                            spatialUI.target.position = pickResult.scenePosition;
                        }
                    }
                }
            }
            onPressed: mouse => {
                if (mouse.buttons & Qt.RightButton) {
                    if (!spatialUI.dragging) {
                        spatialUI.mouseArea.cursorShape = Qt.ClosedHandCursor;
                        spatialUI.dragging = true;
                    } else {
                        spatialUI.dragging = false;
                        spatialUI.mouseArea.cursorShape = Qt.ArrowCursor;
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                border.color: spatialUI.hovered ? "white" : "black"
                border.width: spatialUI.hovered ? 4 : 2
                color: spatialUI.dragging ? "white" : (spatialUI.hovered ? "black" : "white")
                radius: 10

                Text {
                    anchors.centerIn: parent
                    color: spatialUI.hovered ? "white" : "black"
                    font.pixelSize: 16 * spatialUI.scaleFactor
                    text: "SpatialUI"
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
            }
        }

        SpatialItem {
            id: spatialNameTag

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
            target: targetHuman

            linker: ShapePath {
                capStyle: ShapePath.FlatCap
                joinStyle: ShapePath.BevelJoin
                pathHints: ShapePath.PathConvex | ShapePath.PathLinear | ShapePath.PathNonIntersecting
                startX: spatialNameTag.linkerStart.x
                startY: spatialNameTag.linkerStart.y
                strokeColor: spatialNameTag.hovered ? "black" : "white"
                strokeWidth: 1 * spatialNameTag.scaleFactor

                PathLine {
                    x: spatialNameTag.linkerEnd.x
                    y: spatialNameTag.linkerEnd.y
                }

                PathLine {
                    x: spatialNameTag.linkerEnd.x + 20 * spatialNameTag.scaleFactor
                    y: spatialNameTag.linkerEnd.y
                }

                PathLine {
                    x: spatialNameTag.linkerStart.x
                    y: spatialNameTag.linkerStart.y
                }
            }

            Rectangle {
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
                    text: "You spin me right round\nBaby, right round"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
