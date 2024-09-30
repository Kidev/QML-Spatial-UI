import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Shapes
import SpatialUI

Window {
    id: root

    height: 480
    title: qsTr("SpatialUI Example")
    visible: true
    width: 640

    View3D {
        id: view3D

        anchors.fill: parent
        camera: cameraNode

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "skyblue"
        }

        Node {
            id: originNode

            PerspectiveCamera {
                id: cameraNode

                fieldOfView: 45
                position: Qt.vector3d(0, 200, 300)
            }
        }

        OrbitCameraController {
            anchors.fill: parent
            camera: cameraNode
            origin: originNode
            panEnabled: true
        }

        Model {
            id: targetModel

            position: Qt.vector3d(0, 0, 0)
            source: "#Cube"

            materials: [
                DefaultMaterial {
                    diffuseColor: "red"
                }
            ]
        }

        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -70
        }

        SpatialItem {
            id: spatialUI

            camera: cameraNode
            fixedSize: true
            hoverEnabled: true
            mouseEnabled: true
            offset: Qt.vector3d(0, 150, 0)
            showLinker: true
            size: Qt.size(100, 50)
            target: targetModel

            linker: ShapePath {
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.BevelJoin
                pathHints: ShapePath.PathLinear
                startX: spatialUI.linkerStart.x
                startY: spatialUI.linkerStart.y
                strokeColor: "white"
                strokeWidth: 4 * spatialUI.scaleFactor

                PathLine {
                    x: spatialUI.linkerEnd.x
                    y: spatialUI.linkerEnd.y
                }
            }

            onClicked: function (event) {
                console.log(`event=${event}`);
            }
            onEntered: function () {
                console.log(`ENTER`);
            }
            onExited: function () {
                console.log(`EXIT`);
            }
            onHoveredChanged: function () {
                console.log(`hovered=${hovered}`);
            }

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                border.width: 2
                color: "white"
                radius: 10

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 16 * spatialUI.scaleFactor
                    text: "SpatialUI"
                }
            }
        }
    }
}
