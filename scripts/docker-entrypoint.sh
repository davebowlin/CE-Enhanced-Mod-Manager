#!/bin/bash
set -e

# Clear any existing X locks
rm -f /tmp/.X1-lock

# Start Xvfb
echo "Starting Xvfb..."
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# Start Openbox window manager
echo "Starting Openbox..."
openbox-session &
sleep 2

# Start x11vnc
echo "Starting x11vnc..."
x11vnc -display :1 -nopw -forever -shared -quiet &
sleep 2

# Start noVNC using websockify directly (more reliable)
echo "Starting websockify on port 6080..."
websockify --web /opt/novnc 6080 localhost:5900 > /tmp/novnc.log 2>&1 &
sleep 3

if ! pgrep -f websockify > /dev/null; then
    echo "ERROR: websockify failed to start. Check logs below:"
    cat /tmp/novnc.log
fi

if [ "$APP_ENV" = "development" ]; then
    echo "----------------------------------------------------------------"
    echo "  CEE Mod Manager Development Environment"
    echo "  Access the GUI at: http://localhost:6080/"
    echo "  Hot-reload is active. Changes to .py files will restart the app."
    echo "----------------------------------------------------------------"
    # Start the application with hot-reloading
    watchmedo auto-restart --directory=/app --pattern="*.py" --recursive -- python app.py
else
    echo "----------------------------------------------------------------"
    echo "  CEE Mod Manager"
    echo "  Access the GUI at: http://localhost:6080/"
    echo "----------------------------------------------------------------"
    # Start the application normally
    python app.py
fi
