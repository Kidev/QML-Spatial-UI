# QML Spatial UI
The `SpatialItem` component for QtQuick3D allows for creating 2D overlays that stay positioned over 3D models in a `View3D` scene, maintaining a constant perceived size despite changes in camera position or model distance. This is useful for adding labels, controls, or indicators to objects in a 3D environment, enhancing interactivity and context.

#### Demo
[A demo of `SpatialItem` in your browser is available here](#).

### Features

- **2D Content in 3D Space**  
  Easily add any Qt Quick item (Rectangles, Text, Images, etc.) as children of `SpatialItem`, rendering them directly in the 3D world. This allows for flexible, rich UI elements in 3D environments.

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

- **`camera`** (**required**) [PerspectiveCamera]:  
  Defines the reference camera for this SpatialItem. It must be a `PerspectiveCamera` inside a Node, which will be used to compute the distance to the target and project its position to the screen space.

- **`fixedSize`** [bool]:  
  If `true`, the overlay UI will maintain a constant size on the screen regardless of distance to the camera. Defaults to `false`.

- **`hoverEnabled`** [bool]:  
  Determines if the overlay UI can react to hover events. If `true`, the `entered()` and `exited()` signals will be emitted when the mouse enters or leaves the item. Defaults to `false`.

- **`mouseEnabled`** [bool]:  
  If `true`, the overlay UI will respond to mouse events such as clicks, enabling the `clicked()` signal. Defaults to `false`.

- **`offset`** [vector3d]:  
  An offset applied to the position of the target model in 3D space. This is used to adjust the relative position of the overlay UI for better alignment with the 3D target. Defaults to `Qt.vector3d(0, 0, 0)`.

- **`showLinker`** [bool]:  
  If `true`, a line will be drawn connecting the UI overlay to the target model to visually indicate the relationship. Defaults to `false`.

- **`size`** [size]:  
  The base size of the overlay UI in screen space, before applying scaling based on distance. This property can be used to adjust the perceived size of the overlay.

- **`target`** (**required**) [Model]:  
  The 3D model to which the overlay UI is linked. The position of this model is used to determine the screen position for displaying the overlay.

- **`linker`** [ShapePath]:  
  Defines the visual appearance of the linker line between the overlay and the target model. This property can be customized to modify attributes like color, width, and style of the linker.

- **`data`** (**default**) [Item]:  
  Represents the content of the overlay UI. This can be customized to show specific information, such as labels, icons, or controls. As the default property, this means a children of `SpatialItem` will get assigned to it automatically.

#### Read-only Data

- **`hovered`** [bool]:  
  Indicates whether the overlay UI is currently being hovered by the mouse cursor.

- **`linkerEnd`** [vector2d]:  
  Represents the endpoint of the linker line in screen space, which is connected to the center of the overlay UI.

- **`linkerStart`** [vector2d]:  
  Represents the starting point of the linker line in screen space, which is connected to the target model's projected position.

- **`scaleFactor`** [real]:  
  A scaling factor used to adjust the size of the overlay UI based on the distance between the camera and the target. This ensures that the overlay appears to have a fixed size in 3D space, despite changes in perspective: use it to scale font sizes, strole width...

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

### Example usage
Take a look at [the complete example here](https://github.com/Kidev/QML-Spatial-UI/tree/main/example)

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
```

