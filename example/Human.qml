import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: principledMaterial

        alphaMode: PrincipledMaterial.Opaque
        baseColor: "white"
        metalness: 1
        roughness: 1
    }

    Skin {
        id: skin

        inverseBindPoses: [Qt.matrix4x4(1, 1.89643e-08, -2.37663e-07, -2.28663e-08, 2.4869e-14, 0.996832, 0.0795422, -2.85316, 2.38419e-07, -0.0795421, 0.996832, 0.0959081, 0, 0, 0, 1), Qt.matrix4x4(1, -2.66337e-15, 1.41249e-14, 6.71084e-15, 2.32684e-14, 0.989618, 0.143724, -3.77126, -3.19172e-14, -0.143724, 0.989618, 0.340061, 0, 0, 0, 1), Qt.matrix4x4(1, -2.73413e-09, -2.38403e-07, 7.8193e-08, 2.13163e-14, 0.999934, -0.0114677, -4.2825, 2.38419e-07, 0.0114678, 0.999934, -0.327965, 0, 0, 0, 1), Qt.matrix4x4(1, 3.67483e-08, -2.35569e-07, -1.23925e-07, 1.77636e-14, 0.98805, 0.154134, -5.08042, 2.38419e-07, -0.154134, 0.98805, 0.519777, 0, 0, 0, 1), Qt.matrix4x4(1, 9.25201e-08, -2.1974e-07, -4.3036e-07, -2.96296e-12, 0.921643, 0.388039, -5.10401, 2.38423e-07, -0.388039, 0.921643, 1.80496, 0, 0, 0, 1), Qt.matrix4x4(0.242785, 0.0491829, 0.968833, -0.49755, 0.958841, -0.163752, -0.231968, 0.814749, 0.147239, 0.985275, -0.086915, -4.88232, 0, 0, 0, 1), Qt.matrix4x4(-0.937353, -0.212945, 0.275723, 1.67516, 0.185178, -0.974925, -0.123413, 4.61511, 0.29509, -0.0646235, 0.953282, 0.0386467, 0, 0, 0, 1), Qt.matrix4x4(-0.970982, -0.202124, -0.127826, 1.64748, 0.147425, -0.926746, 0.345554, 3.6383, -0.188307, 0.316682, 0.929652, -1.09202, 0, 0, 0, 1), Qt.matrix4x4(0.0944923, -0.340316, -0.935551, 1.26199, -0.0594017, -0.940009, 0.335938, 2.88958, -0.993752, 0.0238298, -0.109039, 0.958844, 0, 0, 0, 1), Qt.matrix4x4(0.249109, -0.488127, -0.836467, 1.58614, 0.0263593, -0.859957, 0.509685, 2.36067, -0.968116, -0.149016, -0.201357, 1.50276, 0, 0, 0, 1), Qt.matrix4x4(0.104383, -0.34462, -0.932921, 1.37225, -0.3729, -0.883172, 0.28452, 2.74659, -0.921982, 0.318187, -0.220697, 0.132108, 0, 0, 0, 1), Qt.matrix4x4(0.0562443, -0.273963, -0.960094, 1.23819, -0.572706, -0.796537, 0.193742, 2.65123, -0.817829, 0.538954, -0.201701, -0.590408, 0, 0, 0, 1), Qt.matrix4x4(-0.0206138, -0.0895648, -0.995767, 0.833897, -0.524862, -0.846726, 0.0870245, 2.69237, -0.850937, 0.524435, -0.0295548, -0.621087, 0, 0, 0, 1), Qt.matrix4x4(0.811919, -0.0441314, 0.5821, -0.889217, -0.518952, -0.511226, 0.685082, 1.83376, 0.267351, -0.858313, -0.437976, 2.59355, 0, 0, 0, 1), Qt.matrix4x4(0.866413, -0.258379, 0.427282, -0.20858, -0.467369, -0.720854, 0.511796, 2.38381, 0.17577, -0.643125, -0.745315, 2.16807, 0, 0, 0, 1), Qt.matrix4x4(0.874295, -0.273048, 0.401314, -0.157627, -0.430529, -0.818057, 0.381349, 2.60406, 0.224171, -0.50619, -0.832778, 1.76536, 0, 0, 0, 1), Qt.matrix4x4(0.156667, -0.389645, -0.907542, 1.35299, -0.0449766, -0.92075, 0.387552, 2.66343, -0.986627, -0.0198986, -0.161776, 1.12915, 0, 0, 0, 1), Qt.matrix4x4(0.101419, -0.205693, -0.973347, 0.917741, -0.588086, -0.80154, 0.108109, 2.81699, -0.802414, 0.561448, -0.202257, -0.685439, 0, 0, 0, 1), Qt.matrix4x4(-0.0612464, -0.145467, -0.987466, 0.912822, -0.567887, -0.808509, 0.154326, 2.67327, -0.820825, 0.570221, -0.0330901, -0.770463, 0, 0, 0, 1), Qt.matrix4x4(-0.186067, -0.0621114, -0.980572, 0.798772, -0.459098, -0.876857, 0.142657, 2.64606, -0.868682, 0.476722, 0.134639, -0.562716, 0, 0, 0, 1), Qt.matrix4x4(-0.00582643, -0.206596, -0.978409, 0.946484, -0.0220866, -0.97816, 0.206675, 2.88038, -0.999739, 0.0228139, 0.00113621, 0.950965, 0, 0, 0, 1), Qt.matrix4x4(-0.0524296, -0.143381, -0.988278, 0.818943, -0.659487, -0.738167, 0.142081, 2.7025, -0.749886, 0.659205, -0.0558561, -1.07902, 0, 0, 0, 1), Qt.matrix4x4(-0.172325, -0.0964683, -0.980305, 0.799897, -0.485022, -0.857882, 0.169682, 2.73542, -0.857355, 0.50471, 0.101046, -0.615843, 0, 0, 0, 1), Qt.matrix4x4(-0.399713, -0.00138964, -0.916639, 0.724597, -0.58226, -0.771953, 0.255072, 2.46072, -0.707957, 0.635678, 0.30775, -1.17805, 0, 0, 0, 1), Qt.matrix4x4(-0.108904, -0.0392256, -0.993278, 0.506438, -0.0714853, -0.996325, 0.0471835, 3.03621, -0.991478, 0.0761432, 0.1057, 0.747268, 0, 0, 0, 1), Qt.matrix4x4(-0.269064, 0.0260143, -0.962771, 0.475081, -0.541545, -0.830731, 0.128898, 2.82912, -0.79645, 0.556066, 0.237608, -0.829167, 0, 0, 0, 1), Qt.matrix4x4(-0.306578, 0.0716955, -0.949141, 0.382587, -0.616538, -0.774664, 0.140629, 2.62975, -0.725184, 0.628295, 0.281698, -1.1047, 0, 0, 0, 1), Qt.matrix4x4(-0.464926, -0.0673504, -0.882784, 0.867716, -0.61685, -0.690613, 0.377558, 2.24459, -0.635091, 0.720082, 0.279539, -1.4254, 0, 0, 0, 1), Qt.matrix4x4(0.242785, -0.0491829, -0.968833, 0.49755, -0.958841, -0.163752, -0.231968, 0.814749, -0.147239, 0.985275, -0.086915, -4.88232, 0, 0, 0, 1), Qt.matrix4x4(-0.937353, 0.212945, -0.275724, -1.67516, -0.185178, -0.974925, -0.123413, 4.61511, -0.29509, -0.0646235, 0.953282, 0.0386467, 0, 0, 0, 1), Qt.matrix4x4(-0.970982, 0.202124, 0.127826, -1.64749, -0.147425, -0.926746, 0.345554, 3.6383, 0.188307, 0.316682, 0.929652, -1.09202, 0, 0, 0, 1), Qt.matrix4x4(0.0944924, 0.340316, 0.935552, -1.26199, 0.0594017, -0.940009, 0.335938, 2.88958, 0.993752, 0.0238297, -0.109039, 0.958844, 0, 0, 0, 1), Qt.matrix4x4(0.249109, 0.488127, 0.836467, -1.58614, -0.0263593, -0.859957, 0.509685, 2.36067, 0.968117, -0.149016, -0.201357, 1.50276, 0, 0, 0, 1), Qt.matrix4x4(0.104383, 0.34462, 0.932921, -1.37225, 0.3729, -0.883173, 0.28452, 2.74659, 0.921982, 0.318187, -0.220697, 0.132108, 0, 0, 0, 1), Qt.matrix4x4(0.0562443, 0.273964, 0.960094, -1.23819, 0.572706, -0.796538, 0.193742, 2.65123, 0.81783, 0.538954, -0.201701, -0.590408, 0, 0, 0, 1), Qt.matrix4x4(-0.0206139, 0.0895649, 0.995768, -0.833898, 0.524863, -0.846727, 0.0870248, 2.69237, 0.850938, 0.524435, -0.0295549, -0.621088, 0, 0, 0, 1), Qt.matrix4x4(0.811919, 0.0441314, -0.5821, 0.889217, 0.518952, -0.511226, 0.685082, 1.83376, -0.267351, -0.858313, -0.437976, 2.59355, 0, 0, 0, 1), Qt.matrix4x4(0.866413, 0.258379, -0.427282, 0.20858, 0.467369, -0.720854, 0.511796, 2.38381, -0.17577, -0.643125, -0.745315, 2.16807, 0, 0, 0, 1), Qt.matrix4x4(0.874295, 0.273048, -0.401314, 0.157627, 0.430529, -0.818057, 0.38135, 2.60406, -0.224171, -0.50619, -0.832778, 1.76536, 0, 0, 0, 1), Qt.matrix4x4(0.156667, 0.389645, 0.907542, -1.35299, 0.0449766, -0.92075, 0.387552, 2.66343, 0.986627, -0.0198986, -0.161776, 1.12915, 0, 0, 0, 1), Qt.matrix4x4(0.101419, 0.205693, 0.973347, -0.917741, 0.588087, -0.80154, 0.108109, 2.81699, 0.802414, 0.561448, -0.202257, -0.685439, 0, 0, 0, 1), Qt.matrix4x4(-0.0612465, 0.145467, 0.987466, -0.912822, 0.567887, -0.808509, 0.154327, 2.67327, 0.820825, 0.570221, -0.0330901, -0.770463, 0, 0, 0, 1), Qt.matrix4x4(-0.186067, 0.0621114, 0.980572, -0.798773, 0.459098, -0.876857, 0.142657, 2.64607, 0.868682, 0.476722, 0.134639, -0.562717, 0, 0, 0, 1), Qt.matrix4x4(-0.00582643, 0.206597, 0.978409, -0.946484, 0.0220866, -0.97816, 0.206676, 2.88038, 0.999739, 0.0228138, 0.00113625, 0.950965, 0, 0, 0, 1), Qt.matrix4x4(-0.0524296, 0.143381, 0.988278, -0.818944, 0.659487, -0.738167, 0.142082, 2.7025, 0.749886, 0.659205, -0.0558562, -1.07902, 0, 0, 0, 1), Qt.matrix4x4(-0.172325, 0.0964683, 0.980305, -0.799898, 0.485022, -0.857882, 0.169682, 2.73542, 0.857355, 0.50471, 0.101046, -0.615843, 0, 0, 0, 1), Qt.matrix4x4(-0.399713, 0.0013897, 0.91664, -0.724597, 0.58226, -0.771953, 0.255072, 2.46072, 0.707957, 0.635678, 0.30775, -1.17805, 0, 0, 0, 1), Qt.matrix4x4(-0.108904, 0.0392256, 0.993278, -0.506438, 0.0714853, -0.996325, 0.0471836, 3.03621, 0.991479, 0.0761432, 0.1057, 0.747268, 0, 0, 0, 1), Qt.matrix4x4(-0.269064, -0.0260143, 0.962771, -0.475081, 0.541545, -0.830731, 0.128898, 2.82912, 0.796451, 0.556066, 0.237608, -0.829167, 0, 0, 0, 1), Qt.matrix4x4(-0.306578, -0.0716955, 0.949142, -0.382587, 0.616538, -0.774664, 0.140629, 2.62975, 0.725184, 0.628295, 0.281698, -1.1047, 0, 0, 0, 1), Qt.matrix4x4(-0.464926, 0.0673506, 0.882784, -0.867716, 0.61685, -0.690613, 0.377559, 2.24459, 0.635091, 0.720082, 0.279539, -1.4254, 0, 0, 0, 1), Qt.matrix4x4(0.997777, 0.0659744, -0.00779016, -0.620574, 0.0656848, -0.99729, -0.0331428, 2.85964, -0.00997476, 0.0325553, -0.999413, 0.0679583, 0, 0, 0, 1), Qt.matrix4x4(0.995727, 0.0918586, 0.00790888, -0.669554, 0.0918531, -0.980955, -0.171143, 1.79682, -0.00798208, 0.171139, -0.985207, -0.192141, 0, 0, 0, 1), Qt.matrix4x4(0.947455, 0.167946, -0.27219, -0.704305, 0.316852, -0.609065, 0.727078, 0.111731, -0.0436801, -0.775134, -0.630283, 0.212061, 0, 0, 0, 1), Qt.matrix4x4(-0.989286, -0.00186149, 0.145868, 0.741377, 0.143227, -0.202891, 0.968665, -0.250257, 0.0277923, 0.979199, 0.200989, -0.14897, 0, 0, 0, 1), Qt.matrix4x4(0.997778, -0.0659745, 0.00779026, 0.620574, -0.0656847, -0.99729, -0.0331427, 2.85964, 0.00997397, 0.0325554, -0.999414, 0.0679578, 0, 0, 0, 1), Qt.matrix4x4(0.995728, -0.0918586, -0.00790888, 0.669554, -0.0918532, -0.980955, -0.171143, 1.79682, 0.00798119, 0.171139, -0.985208, -0.192142, 0, 0, 0, 1), Qt.matrix4x4(0.947456, -0.167947, 0.27219, 0.704306, -0.316851, -0.609065, 0.727078, 0.111731, 0.0436795, -0.775134, -0.630284, 0.21206, 0, 0, 0, 1), Qt.matrix4x4(-0.989287, 0.00186179, -0.145868, -0.741378, -0.143226, -0.202891, 0.968665, -0.250256, -0.027792, 0.979199, 0.200989, -0.14897, 0, 0, 0, 1), Qt.matrix4x4(1, -2.38206e-07, -1.0065e-08, -0.641179, 0, 0.0422159, -0.999109, -0.15398, 2.38419e-07, 0.999109, 0.0422159, -0.344523, 0, 0, 0, 1), Qt.matrix4x4(-1, -1.87148e-08, -1.3485e-06, 0.573757, 5.86824e-09, 0.999834, -0.0182277, -1.42011, 1.34861e-06, -0.0182276, -0.999834, 2.21836, 0, 0, 0, 1), Qt.matrix4x4(1, 2.38206e-07, 1.0065e-08, 0.641179, 0, 0.0422159, -0.999109, -0.15398, -2.38419e-07, 0.999109, 0.0422159, -0.344523, 0, 0, 0, 1), Qt.matrix4x4(-1, 1.87148e-08, 1.3485e-06, -0.573757, -5.86824e-09, 0.999834, -0.0182277, -1.42011, -1.34861e-06, -0.0182276, -0.999834, 2.21836, 0, 0, 0, 1)]
        joints: [hips, spine, chest, neck, head, shoulder_L, upper_arm_L, forearm_L, hand_L, palm_01_L, f_index_01_L, f_index_02_L, f_index_03_L, thumb_01_L, thumb_02_L, thumb_03_L, palm_02_L, f_middle_01_L, f_middle_02_L, f_middle_03_L, palm_03_L, f_ring_01_L, f_ring_02_L, f_ring_03_L, palm_04_L, f_pinky_01_L, f_pinky_02_L, f_pinky_03_L, shoulder_R, upper_arm_R, forearm_R, hand_R, palm_01_R, f_index_01_R, f_index_02_R, f_index_03_R, thumb_01_R, thumb_02_R, thumb_03_R, palm_02_R, f_middle_01_R, f_middle_02_R, f_middle_03_R, palm_03_R, f_ring_01_R, f_ring_02_R, f_ring_03_R, palm_04_R, f_pinky_01_R, f_pinky_02_R, f_pinky_03_R, thigh_L, shin_L, foot_L, toe_L, thigh_R, shin_R, foot_R, toe_R, shin_L_001, thigh_L_001, shin_R_001, thigh_R_001]
    }

    // Nodes:
    Node {
        id: root

        objectName: "ROOT"

        Model {
            id: body

            materials: [principledMaterial]
            objectName: "body"
            skin: skin
            source: "meshes/plane_mesh.mesh"
        }

        Node {
            id: metarig

            objectName: "metarig"

            Node {
                id: hips

                objectName: "hips"
                position: Qt.vector3d(0, 2.85175, 0.131342)
                rotation: Qt.quaternion(0.999208, 0.0398026, 1.19115e-07, 4.74484e-09)
                scale: Qt.vector3d(1, 1, 1)

                Node {
                    id: spine

                    objectName: "spine"
                    position: Qt.vector3d(4.56765e-16, 0.932183, 1.49012e-08)
                    rotation: Qt.quaternion(0.999478, 0.032293, -1.19147e-07, 3.84962e-09)
                    scale: Qt.vector3d(1, 1, 1)

                    Node {
                        id: chest

                        objectName: "chest"
                        position: Qt.vector3d(3.70577e-22, 0.510302, 5.96046e-08)
                        rotation: Qt.quaternion(0.996972, -0.0777671, 1.18848e-07, -9.27056e-09)
                        scale: Qt.vector3d(1, 1, 1)

                        Node {
                            id: neck

                            objectName: "neck"
                            position: Qt.vector3d(-7.9582e-15, 0.8139, -1.11759e-08)
                            rotation: Qt.quaternion(0.996548, 0.0830137, -1.78251e-14, 1.9792e-08)
                            scale: Qt.vector3d(1, 1, 1)

                            Node {
                                id: head

                                objectName: "head"
                                position: Qt.vector3d(7.22246e-15, 0.308331, -2.98023e-08)
                                rotation: Qt.quaternion(0.992582, 0.121575, 2.03806e-12, 2.89874e-08)
                                scale: Qt.vector3d(1, 1, 1)

                                Model {
                                    id: _MergedNode_0

                                    materials: [principledMaterial]
                                    objectName: "$MergedNode_0"
                                    position: Qt.vector3d(0.143035, 0.410995, 0.290406)
                                    rotation: Qt.quaternion(0.980215, -0.197936, -1.16853e-07, -2.35977e-08)
                                    scale: Qt.vector3d(1, 1, 1)
                                    source: "meshes/sphere_001_Sphere_mesh.mesh"
                                }
                            }
                        }

                        Node {
                            id: shoulder_L

                            objectName: "shoulder.L"
                            position: Qt.vector3d(0.0584539, 0.682659, -0.0243154)
                            rotation: Qt.quaternion(0.501521, -0.608169, -0.4098, -0.45899)
                            scale: Qt.vector3d(1, 1, 1)

                            Node {
                                id: upper_arm_L

                                objectName: "upper_arm.L"
                                position: Qt.vector3d(-0.0189881, 0.677922, 0.00226012)
                                rotation: Qt.quaternion(0.568294, -0.437701, 0.599964, -0.354264)
                                scale: Qt.vector3d(1, 1, 1)

                                Node {
                                    id: forearm_L

                                    objectName: "forearm.L"
                                    position: Qt.vector3d(-3.81842e-08, 0.82878, -6.89179e-08)
                                    rotation: Qt.quaternion(0.950829, 0.234308, 0.200015, -0.0319216)
                                    scale: Qt.vector3d(1, 1, 1)

                                    Node {
                                        id: hand_L

                                        objectName: "hand.L"
                                        position: Qt.vector3d(1.11759e-08, 1.00107, 0)
                                        rotation: Qt.quaternion(0.736276, 0.0787998, 0.668683, -0.0674682)
                                        scale: Qt.vector3d(1, 1, 1)

                                        Node {
                                            id: palm_01_L

                                            objectName: "palm.01.L"
                                            position: Qt.vector3d(-0.0729988, 0.126906, -0.0067288)
                                            rotation: Qt.quaternion(0.991301, -0.0585603, 0.0795898, 0.0869398)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_index_01_L

                                                objectName: "f_index.01.L"
                                                position: Qt.vector3d(-1.3411e-07, 0.199629, -5.96046e-08)
                                                rotation: Qt.quaternion(0.96939, 0.218112, -0.0873057, -0.0713338)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_index_02_L

                                                    objectName: "f_index.02.L"
                                                    position: Qt.vector3d(9.68575e-08, 0.0989083, -9.68575e-08)
                                                    rotation: Qt.quaternion(0.992241, 0.115957, -0.0392528, -0.0217082)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_index_03_L

                                                        objectName: "f_index.03.L"
                                                        position: Qt.vector3d(3.72529e-08, 0.111876, 2.98023e-08)
                                                        rotation: Qt.quaternion(0.994465, -0.0272836, -0.0836117, -0.0574869)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }

                                            Node {
                                                id: thumb_01_L

                                                objectName: "thumb.01.L"
                                                position: Qt.vector3d(-0.0270196, -0.0977785, 0.00823852)
                                                rotation: Qt.quaternion(0.60607, -0.033531, 0.721279, 0.333633)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: thumb_02_L

                                                    objectName: "thumb.02.L"
                                                    position: Qt.vector3d(5.96046e-08, 0.128068, -3.42727e-07)
                                                    rotation: Qt.quaternion(0.981159, 0.138267, -0.134795, 0.00635047)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: thumb_03_L

                                                        objectName: "thumb.03.L"
                                                        position: Qt.vector3d(7.45058e-08, 0.108183, 1.78814e-07)
                                                        rotation: Qt.quaternion(0.996399, 0.0833772, -0.0153027, -0.00193096)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_02_L

                                            objectName: "palm.02.L"
                                            position: Qt.vector3d(-0.017052, 0.134072, -0.0263649)
                                            rotation: Qt.quaternion(0.999058, -0.0106273, 0.0327582, 0.0264163)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_middle_01_L

                                                objectName: "f_middle.01.L"
                                                position: Qt.vector3d(2.08616e-07, 0.185141, -2.98023e-08)
                                                rotation: Qt.quaternion(0.94855, 0.299913, -0.0586199, -0.0828795)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_middle_02_L

                                                    objectName: "f_middle.02.L"
                                                    position: Qt.vector3d(2.98023e-08, 0.122335, 3.72529e-08)
                                                    rotation: Qt.quaternion(0.996123, -0.0129384, -0.0842076, 0.0219262)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_middle_03_L

                                                        objectName: "f_middle.03.L"
                                                        position: Qt.vector3d(-2.98023e-08, 0.11798, 9.49949e-08)
                                                        rotation: Qt.quaternion(0.995089, -0.0644518, -0.0750822, -0.00257456)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_03_L

                                            objectName: "palm.03.L"
                                            position: Qt.vector3d(0.0319444, 0.127883, -0.0192968)
                                            rotation: Qt.quaternion(0.996148, -0.0156149, -0.0529153, -0.0681566)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_ring_01_L

                                                objectName: "f_ring.01.L"
                                                position: Qt.vector3d(9.77889e-09, 0.171448, -6.0536e-09)
                                                rotation: Qt.quaternion(0.939083, 0.341404, -0.0333283, -0.0213444)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_ring_02_L

                                                    objectName: "f_ring.02.L"
                                                    position: Qt.vector3d(-5.96046e-08, 0.12051, -1.93715e-07)
                                                    rotation: Qt.quaternion(0.992333, -0.105433, -0.0623944, 0.0163332)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_ring_03_L

                                                        objectName: "f_ring.03.L"
                                                        position: Qt.vector3d(-2.98023e-08, 0.0993515, -5.21541e-08)
                                                        rotation: Qt.quaternion(0.989247, 0.0720515, -0.123929, 0.0290034)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_04_L

                                            objectName: "palm.04.L"
                                            position: Qt.vector3d(0.0781545, 0.114968, -0.00733678)
                                            rotation: Qt.quaternion(0.982922, 0.00491468, -0.110406, -0.147139)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_pinky_01_L

                                                objectName: "f_pinky.01.L"
                                                position: Qt.vector3d(2.98023e-08, 0.189765, 3.1665e-08)
                                                rotation: Qt.quaternion(0.963609, 0.252482, -0.0877102, -0.00405821)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_pinky_02_L

                                                    objectName: "f_pinky.02.L"
                                                    position: Qt.vector3d(0, 0.114509, 8.19564e-08)
                                                    rotation: Qt.quaternion(0.998447, 0.0467241, -0.0296118, -0.00656488)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_pinky_03_L

                                                        objectName: "f_pinky.03.L"
                                                        position: Qt.vector3d(5.96046e-08, 0.0888575, 7.45058e-09)
                                                        rotation: Qt.quaternion(0.991933, 0.0621846, -0.0164207, 0.109239)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Node {
                            id: shoulder_R

                            objectName: "shoulder.R"
                            position: Qt.vector3d(-0.0584539, 0.682659, -0.0243154)
                            rotation: Qt.quaternion(0.501521, -0.608169, 0.4098, 0.458989)
                            scale: Qt.vector3d(1, 1, 1)

                            Node {
                                id: upper_arm_R

                                objectName: "upper_arm.R"
                                position: Qt.vector3d(0.0189881, 0.677922, 0.0022601)
                                rotation: Qt.quaternion(0.568294, -0.437701, -0.599964, 0.354264)
                                scale: Qt.vector3d(1, 1, 1)

                                Node {
                                    id: forearm_R

                                    objectName: "forearm.R"
                                    position: Qt.vector3d(-1.95578e-08, 0.82878, 5.58794e-09)
                                    rotation: Qt.quaternion(0.950828, 0.234308, -0.200015, 0.0319216)
                                    scale: Qt.vector3d(1, 1, 1)

                                    Node {
                                        id: hand_R

                                        objectName: "hand.R"
                                        position: Qt.vector3d(1.3411e-07, 1.00107, -1.49012e-08)
                                        rotation: Qt.quaternion(0.736276, 0.0787998, -0.668683, 0.0674683)

                                        Node {
                                            id: palm_01_R

                                            objectName: "palm.01.R"
                                            position: Qt.vector3d(0.072999, 0.126906, -0.00672881)
                                            rotation: Qt.quaternion(0.991301, -0.0585603, -0.0795897, -0.0869398)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_index_01_R

                                                objectName: "f_index.01.R"
                                                position: Qt.vector3d(-1.63913e-07, 0.199629, -2.23517e-08)
                                                rotation: Qt.quaternion(0.96939, 0.218112, 0.0873057, 0.0713338)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_index_02_R

                                                    objectName: "f_index.02.R"
                                                    position: Qt.vector3d(-2.08616e-07, 0.0989081, 7.45058e-08)
                                                    rotation: Qt.quaternion(0.992241, 0.115957, 0.0392528, 0.0217081)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_index_03_R

                                                        objectName: "f_index.03.R"
                                                        position: Qt.vector3d(6.70552e-08, 0.111877, 2.23517e-08)
                                                        rotation: Qt.quaternion(0.994465, -0.0272837, 0.0836117, 0.0574868)
                                                    }
                                                }
                                            }

                                            Node {
                                                id: thumb_01_R

                                                objectName: "thumb.01.R"
                                                position: Qt.vector3d(0.0270194, -0.0977786, 0.00823856)
                                                rotation: Qt.quaternion(0.60607, -0.033531, -0.721279, -0.333633)

                                                Node {
                                                    id: thumb_02_R

                                                    objectName: "thumb.02.R"
                                                    position: Qt.vector3d(-5.96046e-08, 0.128068, 7.45058e-08)
                                                    rotation: Qt.quaternion(0.981159, 0.138267, 0.134795, -0.00635042)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: thumb_03_R

                                                        objectName: "thumb.03.R"
                                                        position: Qt.vector3d(-7.45058e-08, 0.108184, 4.47035e-08)
                                                        rotation: Qt.quaternion(0.996399, 0.0833771, 0.0153027, 0.00193095)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_02_R

                                            objectName: "palm.02.R"
                                            position: Qt.vector3d(0.0170522, 0.134072, -0.026365)
                                            rotation: Qt.quaternion(0.999058, -0.0106273, -0.0327582, -0.0264162)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_middle_01_R

                                                objectName: "f_middle.01.R"
                                                position: Qt.vector3d(-1.04308e-07, 0.185141, -2.6077e-08)
                                                rotation: Qt.quaternion(0.94855, 0.299913, 0.0586199, 0.0828795)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_middle_02_R

                                                    objectName: "f_middle.02.R"
                                                    position: Qt.vector3d(5.96046e-08, 0.122335, -5.96046e-08)
                                                    rotation: Qt.quaternion(0.996123, -0.0129384, 0.0842076, -0.0219262)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_middle_03_R

                                                        objectName: "f_middle.03.R"
                                                        position: Qt.vector3d(3.35276e-08, 0.11798, -1.09896e-07)
                                                        rotation: Qt.quaternion(0.995089, -0.0644518, 0.0750822, 0.00257458)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_03_R

                                            objectName: "palm.03.R"
                                            position: Qt.vector3d(-0.0319442, 0.127884, -0.0192967)
                                            rotation: Qt.quaternion(0.996148, -0.0156149, 0.0529154, 0.0681567)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_ring_01_R

                                                objectName: "f_ring.01.R"
                                                position: Qt.vector3d(-9.31323e-09, 0.171448, 4.47035e-08)
                                                rotation: Qt.quaternion(0.939083, 0.341404, 0.0333283, 0.0213443)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_ring_02_R

                                                    objectName: "f_ring.02.R"
                                                    position: Qt.vector3d(-7.45058e-09, 0.120511, 6.14673e-08)
                                                    rotation: Qt.quaternion(0.992333, -0.105433, 0.0623944, -0.0163332)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_ring_03_R

                                                        objectName: "f_ring.03.R"
                                                        position: Qt.vector3d(2.98023e-08, 0.0993516, -1.63913e-07)
                                                        rotation: Qt.quaternion(0.989247, 0.0720514, 0.123929, -0.0290035)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: palm_04_R

                                            objectName: "palm.04.R"
                                            position: Qt.vector3d(-0.0781544, 0.114968, -0.00733685)
                                            rotation: Qt.quaternion(0.982922, 0.00491469, 0.110406, 0.147139)
                                            scale: Qt.vector3d(1, 1, 1)

                                            Node {
                                                id: f_pinky_01_R

                                                objectName: "f_pinky.01.R"
                                                position: Qt.vector3d(-2.23517e-08, 0.189765, -1.67638e-08)
                                                rotation: Qt.quaternion(0.963609, 0.252482, 0.0877102, 0.0040582)
                                                scale: Qt.vector3d(1, 1, 1)

                                                Node {
                                                    id: f_pinky_02_R

                                                    objectName: "f_pinky.02.R"
                                                    position: Qt.vector3d(7.45058e-09, 0.114508, -6.70552e-08)
                                                    rotation: Qt.quaternion(0.998447, 0.0467242, 0.0296118, 0.00656486)
                                                    scale: Qt.vector3d(1, 1, 1)

                                                    Node {
                                                        id: f_pinky_03_R

                                                        objectName: "f_pinky.03.R"
                                                        position: Qt.vector3d(-4.47035e-08, 0.0888569, -1.86265e-07)
                                                        rotation: Qt.quaternion(0.991933, 0.0621846, 0.0164207, -0.109239)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Node {
                    id: thigh_L

                    objectName: "thigh.L"
                    position: Qt.vector3d(0.432056, 0.0408586, 0.0233281)
                    rotation: Qt.quaternion(0.0233521, 0.999175, 0.0327347, -0.00575172)
                    scale: Qt.vector3d(1.00001, 1, 1.00001)

                    Node {
                        id: shin_L

                        objectName: "shin.L"
                        position: Qt.vector3d(-6.48433e-08, 1.03644, 5.58794e-09)
                        rotation: Qt.quaternion(0.997476, 0.0693601, 0.00647829, -0.0137184)
                        scale: Qt.vector3d(1, 1, 1)

                        Node {
                            id: foot_L

                            objectName: "foot.L"
                            position: Qt.vector3d(-6.71716e-08, 1.53552, 4.65661e-10)
                            rotation: Qt.quaternion(0.858415, -0.491406, -0.119126, -0.08633)
                            scale: Qt.vector3d(1, 1, 1)

                            Node {
                                id: toe_L

                                objectName: "toe.L"
                                position: Qt.vector3d(1.86265e-08, 0.41742, 7.45058e-09)
                                rotation: Qt.quaternion(0.0474251, -0.0952559, 0.966632, -0.233021)
                                scale: Qt.vector3d(1, 1, 1)
                            }
                        }
                    }
                }

                Node {
                    id: thigh_R

                    objectName: "thigh.R"
                    position: Qt.vector3d(-0.432056, 0.0408586, 0.0233279)
                    rotation: Qt.quaternion(0.0233521, 0.999175, -0.0327346, 0.00575179)
                    scale: Qt.vector3d(1.00001, 1, 1.00001)

                    Node {
                        id: shin_R

                        objectName: "shin.R"
                        position: Qt.vector3d(3.24799e-08, 1.03644, -1.39698e-09)
                        rotation: Qt.quaternion(0.997476, 0.0693601, -0.00647834, 0.0137185)
                        scale: Qt.vector3d(1, 1, 1)

                        Node {
                            id: foot_R

                            objectName: "foot.R"
                            position: Qt.vector3d(6.3912e-08, 1.53552, 1.39698e-08)
                            rotation: Qt.quaternion(0.858415, -0.491406, 0.119126, 0.0863302)
                            scale: Qt.vector3d(1, 1, 1)

                            Node {
                                id: toe_R

                                objectName: "toe.R"
                                position: Qt.vector3d(1.86265e-08, 0.41742, 7.45058e-09)
                                rotation: Qt.quaternion(-0.0474251, 0.095256, 0.966632, -0.233021)
                                scale: Qt.vector3d(1, 1, 1)
                            }
                        }
                    }
                }
            }

            Node {
                id: shin_L_001

                objectName: "shin.L.001"
                position: Qt.vector3d(0.641179, 0.350716, -0.139298)
                rotation: Qt.quaternion(0.721878, -0.69202, 8.60546e-08, -8.24952e-08)

                Node {
                    id: thigh_L_001

                    objectName: "thigh.L.001"
                    position: Qt.vector3d(-0.0674255, -2.28248, 1.20703)
                    rotation: Qt.quaternion(5.75791e-07, 3.82607e-07, 0.728155, 0.685412)
                    scale: Qt.vector3d(1, 1, 1)
                }
            }

            Node {
                id: shin_R_001

                objectName: "shin.R.001"
                position: Qt.vector3d(-0.641179, 0.350716, -0.139298)
                rotation: Qt.quaternion(0.721878, -0.69202, -8.60546e-08, 8.24952e-08)

                Node {
                    id: thigh_R_001

                    objectName: "thigh.R.001"
                    position: Qt.vector3d(0.0674255, -2.28248, 1.20703)
                    rotation: Qt.quaternion(-5.75791e-07, -3.82607e-07, 0.728155, 0.685412)
                    scale: Qt.vector3d(1, 1, 1)
                }
            }
        }
    }

    // Animations:
}
