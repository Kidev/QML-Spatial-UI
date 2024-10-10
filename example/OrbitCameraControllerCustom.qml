// Copyright (C) 2022 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
// Adapted to add configurable panning keys and

import QtQuick
import QtQuick3D

Item {
    id: root

    property int buttonsToPan: Qt.LeftButton
    required property Camera camera
    property alias dragHandlerMove: moveDragHandler
    property alias dragHandlerPan: panDragHandler
    readonly property bool inputsNeedProcessing: status.useMouse || status.isPanning
    property int modifiersToPan: Qt.ControlModifier
    property bool mouseEnabled: true
    required property Node origin
    property bool panEnabled: true
    property bool scrollEnabled: true // only works for mouse, on mobile, the mouseEnabled controls it
    property bool xInvert: false
    property real xSpeed: 0.1
    property bool yInvert: true
    property real ySpeed: 0.1

    signal canceled(eventPoint point)
    signal grabChanged(int transition, eventPoint point)
    signal mouseMovedDragging(vector2d position, vector2d last)
    signal mousePressed(vector2d position)
    signal mouseReleased(vector2d position)
    signal panEnded
    signal panStarted(vector2d position)
    signal panUpdated(vector2d position)

    function _endPan() {
        status.isPanning = false;
        root.panEnded();
    }

    function _mouseMoved(newPos: vector2d) {
        status.currentPos = newPos;
        root.mouseMovedDragging(newPos, status.lastPos);
    }

    function _mousePressed(newPos) {
        root.forceActiveFocus();
        status.currentPos = newPos;
        status.lastPos = newPos;
        status.useMouse = true;
        root.mousePressed(newPos);
    }

    function _mouseReleased(newPos) {
        status.useMouse = false;
        root.mouseReleased(newPos);
    }

    function _panEvent(newPos: vector2d) {
        status.currentPanPos = newPos;
        root.panUpdated(newPos);
    }

    function _startPan(pos: vector2d) {
        status.isPanning = true;
        status.currentPanPos = pos;
        status.lastPanPos = pos;
        root.panStarted(pos);
    }

    implicitHeight: parent.height
    implicitWidth: parent.width

    Connections {
        function onZChanged() {
            // Adjust near/far values based on distance
            let distance = root.camera.z;
            if (distance < 1) {
                root.camera.clipNear = 0.01;
                root.camera.clipFar = 100;
                if (camera.z === 0) {
                    console.warn("camera z set to 0, setting it to near clip");
                    root.camera.z = camera.clipNear;
                }
            } else if (distance < 100) {
                root.camera.clipNear = 0.1;
                root.camera.clipFar = 1000;
            } else {
                root.camera.clipNear = 1;
                root.camera.clipFar = 10000;
            }
        }

        target: root.camera
    }

    DragHandler {
        id: moveDragHandler

        acceptedModifiers: Qt.NoModifier
        enabled: root.mouseEnabled
        target: null

        onActiveChanged: {
            if (active)
                root._mousePressed(Qt.vector2d(centroid.position.x, centroid.position.y));
            else
                root._mouseReleased(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
        onCanceled: point => root.canceled(point)
        onCentroidChanged: {
            root._mouseMoved(Qt.vector2d(centroid.position.x, centroid.position.y), false);
        }
        onGrabChanged: (transition, point) => root.grabChanged(transition, point)
    }

    DragHandler {
        id: panDragHandler

        acceptedButtons: root.buttonsToPan
        acceptedModifiers: root.modifiersToPan
        enabled: root.mouseEnabled && root.panEnabled
        target: null

        onActiveChanged: {
            if (active)
                root._startPan(Qt.vector2d(centroid.position.x, centroid.position.y));
            else
                root._endPan();
        }
        onCanceled: point => root.canceled(point)
        onCentroidChanged: {
            root._panEvent(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
        onGrabChanged: (transition, point) => root.grabChanged(transition, point)
    }

    PinchHandler {
        id: pinchHandler

        property real distance: 0.0

        enabled: root.mouseEnabled
        target: null

        onActiveChanged: {
            if (active) {
                root._startPan(Qt.vector2d(centroid.position.x, centroid.position.y));
                distance = root.camera.z;
            } else {
                root._endPan();
                distance = 0.0;
            }
        }
        onCentroidChanged: {
            root._panEvent(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
        onScaleChanged: {
            root.camera.z = distance * (1 / scale);
        }
    }

    TapHandler {
        onTapped: root.forceActiveFocus() // qmllint disable signal-handler-parameters
    }

    WheelHandler {
        id: wheelHandler

        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        enabled: root.scrollEnabled
        orientation: Qt.Vertical
        target: null

        onWheel: event => {
            let delta = -event.angleDelta.y * 0.01;
            root.camera.z += root.camera.z * 0.1 * delta;
        }
    }

    FrameAnimation {
        id: updateTimer

        running: root.inputsNeedProcessing

        onTriggered: status.processInput(frameTime * 100)
    }

    QtObject {
        id: status

        property vector2d currentPanPos: Qt.vector2d(0, 0)
        property vector2d currentPos: Qt.vector2d(0, 0)
        property bool isPanning: false
        property vector2d lastPanPos: Qt.vector2d(0, 0)
        property vector2d lastPos: Qt.vector2d(0, 0)
        property bool useMouse: false

        function negate(vector) {
            return Qt.vector3d(-vector.x, -vector.y, -vector.z);
        }

        function processInput(frameDelta) {
            if (useMouse) {
                // Get the delta
                var rotationVector = root.origin.eulerRotation;
                var delta = Qt.vector2d(lastPos.x - currentPos.x, lastPos.y - currentPos.y);
                // rotate x
                var rotateX = delta.x * xSpeed * frameDelta;
                if (xInvert)
                    rotateX = -rotateX;
                rotationVector.y += rotateX;

                // rotate y
                var rotateY = delta.y * -ySpeed * frameDelta;
                if (yInvert)
                    rotateY = -rotateY;
                rotationVector.x += rotateY;
                origin.setEulerRotation(rotationVector);
                lastPos = currentPos;
            }
            if (isPanning) {
                let delta = currentPanPos.minus(lastPanPos);
                delta.x = -delta.x;
                delta.x = (delta.x / root.width) * camera.z * frameDelta;
                delta.y = (delta.y / root.height) * camera.z * frameDelta;
                let velocity = Qt.vector3d(0, 0, 0);
                // X Movement
                let xDirection = origin.right;
                velocity = velocity.plus(Qt.vector3d(xDirection.x * delta.x, xDirection.y * delta.x, xDirection.z * delta.x));
                // Y Movement
                let yDirection = origin.up;
                velocity = velocity.plus(Qt.vector3d(yDirection.x * delta.y, yDirection.y * delta.y, yDirection.z * delta.y));
                origin.position = origin.position.plus(velocity);
                lastPanPos = currentPanPos;
            }
        }
    }
}
