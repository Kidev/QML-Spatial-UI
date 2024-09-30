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
        camera: perspectiveCamera

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "skyblue"
        }

        Node {
            id: originNode

            PerspectiveCamera {
                id: perspectiveCamera

                fieldOfView: 45
                position: Qt.vector3d(0, 200, 500)
            }
        }

        OrbitCameraController {
            anchors.fill: parent
            camera: perspectiveCamera
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

            camera: perspectiveCamera
            fixedSize: hovered
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
                strokeColor: spatialUI.hovered ? "black" : "white"
                strokeWidth: 4 * spatialUI.scaleFactor

                PathLine {
                    x: spatialUI.linkerEnd.x
                    y: spatialUI.linkerEnd.y
                }
            }

            onClicked: event => console.log(`event=${event}`)
            onEntered: () => console.log(`ENTER`)
            onExited: () => console.log(`EXIT`)
            onHoveredChanged: () => console.log(`hovered=${hovered}`)

            Rectangle {
                anchors.fill: parent
                border.color: spatialUI.hovered ? "white" : "black"
                border.width: spatialUI.hovered ? 4 : 2
                color: spatialUI.hovered ? "black" : "white"
                radius: 10

                Text {
                    anchors.centerIn: parent
                    color: spatialUI.hovered ? "white" : "black"
                    font.pixelSize: 16 * spatialUI.scaleFactor
                    text: "SpatialUI"
                }
            }
        }
    }
}
