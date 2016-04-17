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
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id: window;
    visible: true
    width: 1920;
    height: 1080;

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;

        hoverEnabled: true;

        onDoubleClicked: {
            if( window.visibility !== Window.FullScreen ) {
                window.visibility = Window.FullScreen;
            } else {
                window.visibility = Window.Windowed;
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

    Column {
        anchors.top: parent.top;
        anchors.topMargin: 20;
        anchors.horizontalCenter: parent.horizontalCenter;
        spacing: 20;

        Label {
            id: directions;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: 18;
            text: "Double-click to enter fullscreen, click button to toggle VSync";
        }

        Label {
            id: windowInfo;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: 18;
            text: window.visibility === Window.FullScreen ? "Fullscreen: App draws directly to screen" :
                                                            "Windowed: Compositor controls when app contents appear on screen";
        }

        Label {
            id: vsyncInfo;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: 18;
            text: "[VSync info placeholder]";
        }
    }

    Rectangle {
        id: rectangle1;
        anchors.verticalCenter: parent.verticalCenter;
        x: 0;
        width: 500;
        height: 500;
        color: "#ff0000";

        SequentialAnimation on x {
            loops: Animation.Infinite;
            PropertyAnimation { to: window.width - rectangle1.width; duration: 2000; }
            PropertyAnimation { to: 0; duration: 2000; }
        }
    }
}
