// Copyright (C) 2022 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
// Improved for additional controls and possibilities by Kidev

import QtQuick
import QtQuick3D

Item {
    id: root

    readonly property real _scrollSpeed: invertScroll ? -scrollSpeed : scrollSpeed
    readonly property vector2d _speedPanning: Qt.vector2d(xInvertPanning ? -xSpeedPanning : xSpeedPanning, yInvertPanning ? -ySpeedPanning : ySpeedPanning)
    readonly property real _xSpeed: xInvert ? -xSpeed : xSpeed
    readonly property real _ySpeed: yInvert ? -ySpeed : ySpeed
    property int buttonsToPan: Qt.RightButton
    required property Camera camera
    readonly property bool inputsNeedProcessing: status.useMouse || status.isPanning
    property bool invertScroll: false
    property int modifiersToPan: Qt.NoModifier
    property bool mouseEnabled: true
    required property Node origin
    property bool panEnabled: true
    property bool scrollEnabled: true
    property real scrollSpeed: 1
    property bool xInvert: false
    property bool xInvertPanning: false
    property real xMaxAngle: 90
    property real xMinAngle: -90
    property real xSpeed: 0.1
    property real xSpeedPanning: 0.5
    property bool yInvert: true
    property bool yInvertPanning: false
    property real yMaxAngle: 361
    property real yMinAngle: -361
    property real ySpeed: 0.1
    property real ySpeedPanning: 0.5

    function _endPan() {
        status.isPanning = false;
    }

    function _mouseMoved(newPos: vector2d) {
        status.currentPos = newPos;
    }

    function _mousePressed(newPos) {
        root.forceActiveFocus();
        status.currentPos = newPos;
        status.lastPos = newPos;
        status.useMouse = true;
    }

    function _mouseReleased(newPos) {
        status.useMouse = false;
    }

    function _panEvent(newPos: vector2d) {
        status.currentPanPos = newPos;
    }

    function _panEventDelta(delta: vector2d) {
        status.currentPanPos = delta.plus(status.lastPanPos);
    }

    function _startPan(pos: vector2d) {
        status.isPanning = true;
        status.currentPanPos = pos;
        status.lastPanPos = pos;
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

    TapHandler {
        onTapped: () => root.forceActiveFocus()
    }

    // Mouse rotation
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
        onCentroidChanged: {
            root._mouseMoved(Qt.vector2d(centroid.position.x, centroid.position.y), false);
        }
    }

    // Mouse pan
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
        onCentroidChanged: {
            root._panEvent(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
    }

    // Mobile rotation
    PinchHandler {
        id: movePinchHandler

        acceptedDevices: PointerDevice.TouchScreen
        acceptedModifiers: Qt.NoModifier
        enabled: root.mouseEnabled
        maximumPointCount: 1
        minimumPointCount: 1
        target: null

        onActiveChanged: {
            if (active)
                root._mousePressed(Qt.vector2d(centroid.position.x, centroid.position.y));
            else
                root._mouseReleased(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
        onCentroidChanged: {
            root._mouseMoved(Qt.vector2d(centroid.position.x, centroid.position.y), false);
        }
    }

    // Mobile zoom
    PinchHandler {
        id: pinchHandlerZoom

        property real distance: active ? root.camera.z : 0.0

        enabled: root.scrollEnabled
        maximumPointCount: 2
        minimumPointCount: 2
        target: null

        onScaleChanged: () => {
            root.camera.z = distance * root._scrollSpeed * (1 / scale);
        }
    }

    // Mobile pan
    PinchHandler {
        id: pinchHandler

        enabled: root.mouseEnabled
        maximumPointCount: 2
        minimumPointCount: 2
        target: null

        onActiveChanged: () => {
            if (active) {
                root._startPan(Qt.vector2d(centroid.position.x, centroid.position.y));
            } else {
                root._endPan();
            }
        }
        onCentroidChanged: () => {
            root._panEvent(Qt.vector2d(centroid.position.x, centroid.position.y));
        }
    }

    // Mouse zoom
    WheelHandler {
        id: wheelHandler

        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        enabled: root.scrollEnabled
        orientation: Qt.Vertical
        target: null

        onWheel: event => {
            let delta = -event.angleDelta.y * 0.01;
            root.camera.z += root.camera.z * 0.1 * delta * root._scrollSpeed;
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

        function clamp(val, min, max) {
            return Math.min(Math.max(val, min), max);
        }

        function negate(vector) {
            return Qt.vector3d(-vector.x, -vector.y, -vector.z);
        }

        function processInput(frameDelta) {
            if (useMouse) {
                // Get the delta
                var rotationVector = root.origin.eulerRotation;
                var delta = Qt.vector2d(lastPos.x - currentPos.x, lastPos.y - currentPos.y);
                // rotate x
                var rotateX = delta.x * _xSpeed * frameDelta;
                rotationVector.y = clamp((rotationVector.y + rotateX) % 360, yMinAngle, yMaxAngle);

                // rotate y
                var rotateY = delta.y * -_ySpeed * frameDelta;
                rotationVector.x = clamp((rotationVector.x + rotateY) % 360, xMinAngle, xMaxAngle);
                origin.setEulerRotation(rotationVector);
                lastPos = currentPos;
            }
            if (isPanning) {
                let delta = currentPanPos.minus(lastPanPos).times(_speedPanning);
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
