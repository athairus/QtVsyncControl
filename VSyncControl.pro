#
# Copyright © 2016 athairus
#
# This file is part of VSyncControl.
#
# VSyncControl is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

##
## Qt settings
##

    # Undefine this (for some reason it's on by default on Windows)
    CONFIG -= debug_and_release debug_and_release_target

    TEMPLATE += app

    QT += qml quick

##
## Compiler settings
##

    CONFIG += c++11

    OBJECTS_DIR = obj
    MOC_DIR     = moc
    RCC_DIR     = rcc
    UI_DIR      = gui

    # Include libraries
    # INCLUDEPATH += /path/to/include

    SOURCES += main.cpp \
    customwindow.cpp

    HEADERS += \
    customwindow.h

    RESOURCES += qml.qrc

##
## Linker settings
##

    ##
    ## Library paths
    ##

    # Externals
    # LIBS += -L/path/to/lib

    ##
    ## Libraries
    ##

    # Externals
    # LIBS += -llibname
