# QML Spatial UI
The `SpatialItem` component for QtQuick3D allows for creating 2D overlays that stay positioned over 3D models in a `View3D` scene, maintaining a constant perceived size despite changes in camera position or model distance. This is useful for adding labels, controls, or indicators to objects in a 3D environment, enhancing interactivity and context.

### Demo
[A demo of `SpatialItem` in your browser is available here](#).

### Features

- **2D Content in 3D Space**  
  Easily add any Qt Quick item (`Rectangle`, `Text`, `Image`, etc.) as children of `SpatialItem`, rendering them in an overlay above the 3D world. This allows for flexible, rich spaptial UI elements in 3D environments.

- **Billboard in Overlay**  
  The item always faces the camera, ensuring visibility from any angle, and can be rendered in front of 3D objects since it is not part of the 3D world. This creates a clear and accessible visual representation.

- **Offset Positioning**  
  Precisely position the content relative to its anchor point in 3D space using the `offset` property. This is useful for fine-tuning the location of the overlay UI in relation to the associated 3D model.

- **3D Linker**  
  Optionally display a customizable indicator (line or shape) between the anchor point and the content, providing a visual link to the 3D object it's associated with. This helps to clearly establish a connection between 2D overlays and their 3D counterparts.

- **Dynamic Sizing**  
  Choose between a fixed size in 3D world space or a size that adapts based on the camera distance. This allows you to keep the UI consistent in appearance whether the camera is near or far, depending on the user experience you're aiming to provide.

- **Screen-Space Alignment**  
  When using fixed-distance-based sizing, the content behaves like a 2D element, making it straightforward to control its size and alignment.

- **Attachment Options**  
  Easily anchor the content to 3D world entities, allowing for flexible positioning and association with various elements in the scene.

- **Interactive Events**  
  Receive events when the item is hovered over, clicked, or touched, enabling interactive overlays. Use `hoverEnabled` and `mouseEnabled` to define the interaction behavior.

- **Dynamic Property Changes**  
  All properties of `SpatialItem` can be updated dynamically, allowing for responsive and interactive 3D UIs that change based on user actions or other conditions in the application.

### Documentation: SpatialItem

#### Properties

- **`data`** (**default**) [Item]:  
  Represents the content of the overlay UI. This can be customized to show specific information, such as labels, icons, or controls. As the default property, this means a children of `SpatialItem` will get assigned to it automatically.

- **`camera`** (**required**) [PerspectiveCamera]:  
  Defines the reference camera for this SpatialItem. It must be a `PerspectiveCamera` inside a `Node`, which will be used to compute the distance to the target and project its position to the screen space.

- **`size`** (**required**) [size]:  
  The base size of the overlay UI in screen space, before applying scaling based on distance. This property can be used to adjust the perceived size of the overlay.

- **`target`** (**required**) [Model]:  
  The 3D model to which the overlay UI is linked. The position of this model is used to determine the screen position for displaying the overlay.

- **`linker`** [ShapePath]:  
  Defines the visual appearance of the linker line between the overlay and the target model. This property can be customized to modify attributes like color, width, and style of the linker.

- **`fixedSize`** [bool]:  
  If `true`, the overlay UI will maintain a constant size on the screen regardless of distance to the camera. Defaults to `false`.

- **`closeUpScaling`** [bool]:  
  If `true` and if `fixedSize` is `true`, then the size will be allowed to grow to accomodate for close camera proximity. The fixed size hence becomes a minimum screen size. Defaults to `false`.

- **`depthTest`** [bool]:  
  If `true` then the 2D items will order themselves as if they were in 3D space: if the camera is closer to a target than another, its UI will be displayed on top. Defaults to `false`.

- **`hoverEnabled`** [bool]:  
  Determines if the overlay UI can react to hover events. If `true`, the `entered()` and `exited()` signals will be emitted when the mouse enters or leaves the item. Defaults to `false`.

- **`mouseEnabled`** [bool]:  
  If `true`, the overlay UI will respond to mouse events such as clicks, enabling the `clicked()` signal. Defaults to `false`.

- **`offsetLinkEnd`** [vector3d]:  
  An offset applied to the position of the target model in 3D space. This is used to adjust the relative position of the overlay UI for better alignment with the 3D target. Defaults to `Qt.vector3d(0, 0, 0)`.

- **`offsetLinkStart`** [vector3d]:  
  An offset applied to the position of the target model in 3D space. This is used to adjust the relative position of start of the linker for better alignment with the 3D target. Defaults to `Qt.vector3d(0, 0, 0)`.

- **`showLinker`** [bool]:  
  If `true`, a line will be drawn connecting the UI overlay to the target model to visually indicate the relationship. Defaults to `false`.

- **`stackingOrder`** [real]:  
  The z value of the contents of the UI. It competes with all its other siblings only. Only active if `depthTest` is `false`. Defaults to `0`.

- **`stackingOrderLinker`** [real]:  
  The z value of the linker shape. Being a children of the UI, it only competes with it, and it can be placed behind by using `-1`. Defaults to `-1`.

#### Read-only Data

- **`hovered`** [bool]:  
  Indicates whether the overlay UI is currently being hovered by the mouse cursor.

- **`linkerEnd`** [vector2d]:  
  Represents the endpoint of the linker line in screen space, which is connected to the center of the overlay UI.

- **`linkerStart`** [vector2d]:  
  Represents the starting point of the linker line in screen space, which is connected to the target model's projected position.

- **`scaleFactor`** [real]:  
  A scaling factor used to adjust the size of the overlay UI based on the distance between the camera and the target. This ensures that the overlay appears to have a fixed size in 3D space, despite changes in perspective: use it to scale font sizes, stroke width...

#### Signals

- **`clicked(MouseEvent)`**:  
  Emitted when the overlay UI is clicked. The `MouseEvent` contains information about the click event, such as the position and button used.

- **`entered()`**:  
  Emitted when the mouse cursor enters the overlay UI.

- **`exited()`**:  
  Emitted when the mouse cursor leaves the overlay UI.

### Add to your project
- Add the project as a submodule from your project root
    - Don't forget to add `--recurse-submodules` when cloning, or run `git submodule update --init`
    - To update the version of SpatialUI your have on your project `git submodule update --remote`
```bash
git submodule add -b main https://github.com/Kidev/QML-Spatial-UI libs/QMLSpatialUI
```
- Add in your `CMakeLists.txt`
```cmake
add_subdirectory(libs/QMLSpatialUI)
```
- Then you can import in QML and use `SpatialItem`:
```qml
import SpatialUI
```

### Example
Take a look at [the complete example here](https://github.com/Kidev/QML-Spatial-UI/tree/main/example) \
To run locally the example, edit `build.sh` and set `QT_ROOT` to your Qt installation architecture folder. Then run `make`

```qml
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

        Human {
            id: targetHuman

            eulerRotation: Qt.vector3d(0, 0, 0)
            pivot: Qt.vector3d(-20, 0, 0)
            position: Qt.vector3d(100, -50, 0)
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

            camera: perspectiveCamera
            closeUpScaling: true
            fixedSize: hovered
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

        SpatialItem {
            id: spatialNameTag

            camera: perspectiveCamera
            closeUpScaling: true
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
                strokeWidth: 4 * spatialNameTag.scaleFactor

                PathLine {
                    x: spatialNameTag.linkerEnd.x
                    y: spatialNameTag.linkerEnd.y
                }

                PathLine {
                    x: spatialNameTag.linkerEnd.x + 20
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
```

### Credits
- [aaravanimates](https://free3d.com/user/aaravanimates) for the [human 3D model](https://free3d.com/3d-model/rigged-male-human-442626.html) of the example 