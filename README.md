# QML Spatial UI
QML Spatial UI is a library designed for creating interactive and dynamic 2D overlays for 3D models in a QML-based user interface. It provides a flexible way to link 2D elements, such as labels, icons, or controls, to specific objects in 3D space, while maintaining the proper visual relationship as the camera or objects move. This makes it particularly useful for creating augmented reality interfaces, games, or spatial annotations. 

## Demo

 [A demo of SpatialItem in your browser is available here](https://demo.kidev.org/QML-Spatial-UI/). \
 This demo showcases the interaction between 2D overlays and 3D objects, demonstrating how the UI elements dynamically adjust to camera movements. Moreover, it highlights the possibilities of the tool by implementing a 3D move tool: just press and hold left mouse button on the "SpatialUI" text!

## Features

- **2D Overlay Anchored to 3D Models**: Easily attach 2D UI elements to 3D models in a scene, ensuring they move and stay in place relative to their corresponding targets.
- **Perspective Scaling**: The overlay size can be adjusted automatically based on distance from the camera, providing a realistic spatial feel.
- **Customizable Linkers**: Add visual linkers between overlays and 3D objects, with options to customize color, width, and style, providing a clear connection between information and its related model.
- **Hover and Mouse Interaction**: Enable user interactions with overlays, including hover effects, clicks, and other mouse events, suitable for creating interactive UI elements.
- **Depth Ordering**: Manage the depth of overlay elements, with support for depth testing and force stacking to ensure the correct display hierarchy.
- **Fixed and Dynamic Sizing**: Choose between fixed overlay sizes, regardless of distance, or allow overlays to scale based on camera proximity.
- **Offset Adjustments**: Fine-tune the overlay positioning using offsets to ensure perfect alignment with the target 3D model.
- **Linker Visibility Control**: Toggle the visibility of linkers to highlight or simplify the display, depending on user needs.
- **Dynamic Signal Handling**: Use built-in signals like `clicked()`, `pressed()`, `entered()`, and more to add interactivity to spatial UI components.

## Documentation: SpatialItem

### Properties

- **data (_default_) [Item]**: Represents the content of the overlay UI. This can be customized to show specific information, such as labels, icons, or controls. As the default property, children of SpatialItem are automatically assigned to it.
  
- **camera (_required_) [PerspectiveCamera]**: Defines the reference camera for this SpatialItem. It must be a PerspectiveCamera inside a Node, which will be used to compute the distance to the target and project its position to screen space.
  
- **size (_required_) [size]**: The base size of the overlay UI in screen space before applying scaling based on distance. This property can be used to adjust the perceived size of the overlay.

- **target (_required_) [Node]**: The 3D model to which the overlay UI is linked. The position of this model determines the screen position for displaying the overlay.

- **linker [ShapePath]**: Defines the visual appearance of the linker line between the overlay and the target model. This property can be customized to modify attributes like color, width, and style of the linker. There is no default, so here is a simple line joining the target to the UI:
  <details><summary>Linker examples</summary>

    - A simple line
    ```QML
    ShapePath {
        startX: linkerStart.x
        startY: linkerStart.y
        strokeColor: "black"
        strokeWidth: 4 * scaleFactor
        PathLine {
            x: linkerEnd.x
            y: linkerEnd.y
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: "white"
        radius: 10
    
        Text {
            anchors.centerIn: parent
            color: "black"
            font.pixelSize: 16 * scaleFactor
            text: "SpatialUI"
        }
    }
    ```
    - In the style of a speech bubble
    ```QML
    ShapePath {
        capStyle: ShapePath.FlatCap
        fillColor: "white"
        joinStyle: ShapePath.BevelJoin
        startX: linkerEnd.x
        startY: linkerEnd.y - uiRectangle.border.width + (uiRectangle.height / 2) - 1
        strokeColor: hovered ? "black" : "white"
        strokeWidth: 1 * scaleFactor
    
        PathLine {
            x: linkerStart.x
            y: linkerStart.y
        }
    
        PathLine {
            x: linkerEnd.x + 20 * scaleFactor
            y: linkerEnd.y - uiRectangle.border.width + (uiRectangle.height / 2) - 1
        }
    }
    
    Rectangle {
        id: uiRectangle
    
        anchors.fill: parent
        border.color: hovered ? "black" : "white"
        border.width: 2
        color: "white"
        radius: 25
    
        Text {
            anchors.centerIn: parent
            color: "black"
            font.pixelSize: 15.0 * scaleFactor
            horizontalAlignment: Text.AlignHCenter
            text: "Hello!"
            verticalAlignment: Text.AlignVCenter
        }
    }
    ```
  </details>

- **fixedSize [bool]**: If true, the overlay UI will maintain a constant size on the screen regardless of distance to the camera. Defaults to false.

- **closeUpScaling [bool]**: If true and if fixedSize is true, then the size will be allowed to grow to accommodate close camera proximity. The fixed size hence becomes a minimum screen size. Defaults to false.

- **depthTest [bool]**: If true, then the 2D items will order themselves as if they were in 3D space: if the camera is closer to a target than another, its UI will be displayed on top. Defaults to false.

- **forceTopStacking [bool]**: If true, then the 2D items of this SpatialItem will be placed on top of their siblings. This is useful for bindings such as hovering. If multiple siblings have this set to true, they will be displayed in the order they appear in the code. Defaults to false.

- **hoverEnabled [bool]**: Determines if the overlay UI can react to hover events. If true, the `entered()` and `exited()` signals will be emitted when the mouse enters or leaves the item. Defaults to false.

- **mouseEnabled [bool]**: If true, the overlay UI will respond to mouse events such as clicks, enabling the `clicked()` signal. Defaults to false.

- **offsetLinkEnd [vector3d]**: An offset applied to the position of the target model in 3D space. This adjusts the relative position of the overlay UI for better alignment with the 3D target. Defaults to `Qt.vector3d(0, 0, 0)`.

- **offsetLinkStart [vector3d]**: An offset applied to the position of the target model in 3D space. This adjusts the relative position of the start of the linker for better alignment with the 3D target. Defaults to `Qt.vector3d(0, 0, 0)`.

- **showLinker [bool]**: If true, a line will be drawn connecting the UI overlay to the target model to visually indicate the relationship. Defaults to false.

- **stackingOrder [real]**: The z-value of the contents of the UI. It competes with all its other siblings only and is active only if `depthTest` is false. Defaults to 0.

- **stackingOrderLinker [real]**: The z-value of the linker shape. As a child of the UI, it only competes with it and can be placed behind using -1. Defaults to -1.

### Read-only Data

- **hovered [bool]**: Indicates whether the overlay UI is currently being hovered by the mouse cursor.

- **linkerEnd [vector2d]**: Represents the endpoint of the linker line in screen space, connected to the center of the overlay UI.

- **linkerStart [vector2d]**: Represents the starting point of the linker line in screen space, connected to the target model's projected position.

- **scaleFactor [real]**: A scaling factor used to adjust the size of the overlay UI based on the distance between the camera and the target. This ensures that the overlay appears to have a fixed size in 3D space, despite changes in perspective. Use it to scale font sizes, stroke width, etc.

### Signals and Aliases

Signals available:
- `canceled()`
- `clicked(MouseEvent mouse)`
- `doubleClicked(MouseEvent mouse)`
- `entered()`
- `exited()`
- `positionChanged(MouseEvent mouse)`
- `pressAndHold(MouseEvent mouse)`
- `pressed(MouseEvent mouse)`
- `released(MouseEvent mouse)`
- `wheel(WheelEvent wheel)`

The MouseArea whose signals are re-shared by the SpatialItem can be accessed freely using the `mouseArea` property alias of SpatialItem.

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

### Simple example
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
```
### Advanced use and running the example
- For more advanced uses, tricks, and deploys, you can check [the complete code of the demo here](https://github.com/Kidev/QML-Spatial-UI/tree/main/example) \
- To build the demo for desktop:
  - Install Qt for `gcc_64`.  
  - Set `QT_ROOT` and `QT_VERSION` to the appropriate values for your Qt installation, then run `make`: \
    `export QT_VERSION="6.6.0" && QT_ROOT="/opt/Qt" && make`  
- To build the demo for the web:
  - Install Qt for `gcc_64` AND `wasm_multithread`.  
  - Enable the following headers on your server:  
    ```
    Cross-Origin-Opener-Policy: same-origin
    Cross-Origin-Embedder-Policy: require-corp
    ```
  - Set `QT_ROOT`, `QT_VERSION` and [`EMSDK_VERSION`](https://doc.qt.io/qt-6/wasm.html) to the appropriate values for your Qt installation, then run `make web`: \
    `export QT_VERSION="6.6.0" && QT_ROOT="/opt/Qt" && EMSDK_VERSION="3.1.37" && make web`
  - You can use `make run` / `make run-web` to run the desktop version / to run the web version in your favorite browser.


## Credits
- [aaravanimates](https://free3d.com/user/aaravanimates) for the [human 3D model](https://free3d.com/3d-model/rigged-male-human-442626.html) of the example (Personal Use License)
- [Roundicons](https://www.flaticon.com/authors/roundicons) for the [move icon](https://www.flaticon.com/free-icons/move) of the example (Flaticon License)
