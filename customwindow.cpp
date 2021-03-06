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

#include "customwindow.h"

#include <QDebug>
#include <QOpenGLContext>
#include <QQuickWindow>
#include <QSurfaceFormat>
#include <QTimer>
#include <QWindow>
#include <memory>

CustomWindow::CustomWindow( QWindow *parent ) : QQuickWindow( parent ) {
    connect( this, &CustomWindow::vsyncChanged, this, &CustomWindow::vsyncChangedHandler );

    // Reinitalize the scene graph when the OpenGL context gets destroyed
    // Needed because only when the context gets recreated is the format read
    setPersistentOpenGLContext( false );
    setPersistentSceneGraph( false );

    // Grab window surface format as the OpenGL context will not be created yet
    QSurfaceFormat fmt = format();

#if defined( Q_OS_WIN )

    // Set buffering mode
    // Testing shows that on Windows, vsync stays on (swapBuffers() blocks) while single buffered
    // even when the swap interval is 0 and even while fullscreen! So, we have to turn on double buffering if we
    // want vsync to actually be off, but turn on single buffering while vsynced to avoid unnecessary additional latency
    fmt.setSwapBehavior( vsync ? QSurfaceFormat::SingleBuffer : QSurfaceFormat::DoubleBuffer );
    emit doubleBufferedChanged( fmt.swapBehavior() == QSurfaceFormat::DoubleBuffer );

#elif defined( Q_OS_MACX )

    fmt.setSwapBehavior( QSurfaceFormat::SingleBuffer );
    emit doubleBufferedChanged( fmt.swapBehavior() == QSurfaceFormat::DoubleBuffer );

    // For proper OS X fullscreen
    setFlags( flags() | Qt::WindowFullscreenButtonHint );

#endif

    // Enforce the default value for vsync
    fmt.setSwapInterval( vsync ? 1 : 0 );
    setFormat( fmt );

}

void CustomWindow::vsyncChangedHandler( bool vsync ) {
    QSurfaceFormat fmt = format();

    // Grab OpenGL context surface format if it's ready to go, it's more filled out than the window one
    // It can be unitialized on startup before so check that it exists before using it
    if( openglContext() ) {
        fmt = openglContext()->format();
    }

#if defined( Q_OS_WIN )

    fmt.setSwapBehavior( vsync ? QSurfaceFormat::SingleBuffer : QSurfaceFormat::DoubleBuffer );

#elif defined( Q_OS_MACX )

    // Leave it alone, OS X happily accepts single buffering

#endif

    fmt.setSwapInterval( vsync ? 1 : 0 );

    // Window must be reset to apply the changes
    resetPlatformWindow( fmt );

    emit doubleBufferedChanged( fmt.swapBehavior() == QSurfaceFormat::DoubleBuffer );
}

void CustomWindow::resetPlatformWindow( QSurfaceFormat fmt ) {
    // qDebug() << "=====================" << __PRETTY_FUNCTION__ << "=====================";

    // Show the window if hidden
    if( !isVisible() ) {
        show();
    }

    Qt::WindowState savedWindowState = windowState();

#if defined( Q_OS_WIN )

    // Force into windowed mode to get proper position and size
    setWindowState( Qt::WindowNoState );

#elif defined( Q_OS_MACX )

    // Force into windowed mode to get proper position and size
    // Don't do this if we're already fullscreen on OS X, it'll happen automatically
    if( !( savedWindowState & Qt::WindowFullScreen ) ) {
        setWindowState( Qt::WindowNoState );
    }

#endif

    QPoint savedPosition = position();
    QSize savedSize = size();


#if defined( Q_OS_WIN )

    // Destroy the window and force the context to be reloaded
    destroy();

#elif defined( Q_OS_MACX )

    // Hide the window and force the QSG to reset it and its context
    hide();

#endif

    releaseResources();
    setFormat( fmt );

    show();

    setPosition( savedPosition );
    resize( savedSize );

#if defined( Q_OS_WIN )

    setWindowState( savedWindowState );

#elif defined( Q_OS_MACX )

    // On OS X, if fullscreen wait for animation to finish before going back
    // If you try to go to fullscreen during the animation, the system makes a denied sound and doesn't do anything
    // FIXME: What if the user tweaks their animation to be slower?
    // FIXME: This approach sucks either way
    if( savedWindowState & Qt::WindowFullScreen ) {
        QTimer::singleShot( 750, this, SLOT( showFullScreen() ) );
    }

#endif

    // qDebug() << "==========================================================";
}

bool CustomWindow::isDoubleBuffered() {
    return format().swapBehavior() == QSurfaceFormat::DoubleBuffer;
}
