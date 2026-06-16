#!/bin/bash

echo "Building turnstile-dbus v2.5.0..."

gcc -o turnstile-dbus src/turnstile-dbus-final.c \
    -I/usr/include/dbus-1.0 \
    -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include \
    -I/usr/include/turnstile \
    -ldbus-1 \
    -lturnstile-highlevel \
    -lturnstile \
    -lpthread

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "New methods in v2.4.0:"
    echo "  • SetWallMessage(message)"
    echo "  • ScheduleShutdown(type, usec)"
    echo "  • CancelScheduledShutdown()"
    echo "  • Inhibit(what, who, why, mode)"
    echo "  • GetSession(session_id) → object_path"
    echo "  • GetActiveSeat() - improved"
    echo ""
    echo "New config options:"
    echo "  • power_management"
    echo "  • suspend_method"
    echo "  • hibernate_method"
    echo "  • auto_activate_sessions"
    echo "  • default_seat"
    echo "  • dbus_timeout"
    echo "  • polkit_enabled"
    echo "  • fallback_enabled"
    echo ""
    echo "Run: sudo ./turnstile-dbus"
else
    echo "❌ Build failed!"
    exit 1
fi
