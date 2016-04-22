/*
 * Copyright © 2016 athairus
 *
 * This file is part of VSyncControl.
 *
 * VSyncControl is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// main.qml: Simple moving box demo to illustrate smooth motion/tearing depending on settings

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import custom.window 1.0

CustomWindow {
    id: window;
    width: Screen.width * 0.7;
    height: Screen.height * 0.7;
    x: Screen.width / 2 - width / 2;
    y: Screen.height / 2 - height / 2;
    visible: true;
    vsync: false;

    onWidthChanged: {
        leftAnimation.to = window.width - rectangle1.width;
        animation.restart();
    }

    color: "#202020";

    Column {
        anchors.top: parent.top;
        anchors.topMargin: 20;
        anchors.horizontalCenter: parent.horizontalCenter;
        spacing: 20;
        z: 1;

        property int textSize: 14;
        property color textColor: "white";

        Label {
            id: directions;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: parent.textSize;
            color: parent.textColor;
            text: "Double-click to enter fullscreen, click button to toggle VSync";
        }

        Label {
            id: windowInfo;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: parent.textSize;
            color: parent.textColor;
            text: window.visibility === Window.FullScreen ? "Fullscreen: Compositor off, app draws directly to screen (Windows: VSync toggleable, OS X: No difference)" :
                                                            "Windowed: Compositor controls when app contents appear on screen (Windows: VSync forced on, OS X: No difference)";
        }

        Label {
            id: bufferingInfo;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: parent.textSize;
            color: parent.textColor;
            text: "Buffering mode: " + ( doubleBuffered ?
                                         "Double buffering" :
                                         "Single buffering" );
        }

        Label {
            id: vsyncInfo;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: parent.textSize;
            color: parent.textColor;
            text: window.vsync ? "VSync on (swap interval = 1, block on swapBuffers() until 1 vblank occurs)" :
                                 "VSync off (swap interval = 0, swapBuffers() does not block)";
        }

        Button {
            id: vsyncToggle;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Toggle VSync";
            onClicked: {
                if( window.vsync ) window.vsync = false;
                else window.vsync = true;
            }
        }
    }

    // Simple rectangle that moves from side to side
    Rectangle {
        id: rectangle1;
        anchors.verticalCenter: parent.verticalCenter;
        x: 0;
        width: 400;
        height: 400;
        color: "#ff0000";

        SequentialAnimation on x {
            id: animation;
            loops: Animation.Infinite;

            // Reset the position if the animation was restarted partway through
            ScriptAction { script: if( rectangle1.x != 0 ) rectangle1.x = 0; }

            PropertyAnimation { id: leftAnimation; to: window.width - rectangle1.width; duration: 2000; }
            PropertyAnimation { id: rightAnimation; to: 0; duration: 2000; }
        }
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;

        hoverEnabled: true;

        property int savedState;

        onDoubleClicked: {
            if( window.visibility !== Window.FullScreen ) {
                savedState = window.visibility;
                window.visibility = Window.FullScreen;
            } else {
                window.visibility = savedState;
            }
        }

        Rectangle {
            id: mouseTracker;
            width: 20;
            height: 20;
            x: mouseArea.mouseX - ( width / 2 );
            y: mouseArea.mouseY - ( height / 2 );
            color: "green";
        }
    }
}
