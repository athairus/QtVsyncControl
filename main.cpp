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

// main.cpp: Entry point

#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlApplicationEngine>

#include <cstdlib>

#include "customwindow.h"

int main( int argc, char *argv[] ) {
    // Generates a MASSSIVE amount of debugging info per frame
    // putenv( ( char* )"QT_LOGGING_RULES=qt.scenegraph.renderloop=true" );

    // This is the most direct way to set the render loop type
    putenv( ( char* )"QSG_RENDER_LOOP=threaded" );

    // Set the time to idle from the first update request until it is delivered (default 5ms)
    // putenv( ( char* )"QT_QPA_UPDATE_IDLE_TIME=10" );

    QGuiApplication app( argc, argv );

    qmlRegisterType<CustomWindow>( "custom.window", 1, 0, "CustomWindow" );

    QQmlApplicationEngine engine;
    engine.load( QUrl( QStringLiteral( "qrc:/main.qml" ) ) );

    return app.exec();
}
