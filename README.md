# QtVsyncControl
An example app that lets the user dynamically toggle VSync during runtime.

# About
The included class `CustomWindow` is a `QQuickWindow` that has a `vsync` property. Set this to true or false to enable or disable VSync. Currently, it will destroy (on Windows) or hide (on OS X) the window and show it once more to apply the change. 

# Limitations
Windows will spawn in an odd place (top left corner center of screen) unless you explicitly set the `x` and `y` properties of the window.

# License
Licensed under GPLv3
