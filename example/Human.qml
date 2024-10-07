import QtQuick
import QtQuick3D

Node {
    id: node

    ResourceLoader {
        meshSources: [body.source]
    }

    PrincipledMaterial {
        id: principledMaterial

        alphaMode: PrincipledMaterial.Opaque
        baseColor: "black"
        metalness: 0
        roughness: 1
    }

    Node {
        id: root

        Model {
            id: body

            castsShadows: true
            materials: [principledMaterial]
            receivesShadows: true
            source: "meshes/human.mesh"
        }
    }
}
