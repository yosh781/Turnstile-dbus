#!/bin/bash

echo "Building turnstile-dbus v2.6.0 with KDE support..."

gcc -o turnstile-dbus src/turnstile-dbus-final.c \
    -I/usr/include/dbus-1.0 \
    -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include \
    -I/usr/include/turnstile \
    -ldbus-1 \
    -lturnstile-highlevel \
    -lturnstile \
    -lpthread

if [ $? -eq 0 ]; then
    echo "✅ Build successful with KDE support!"
    echo ""
    echo "KDE-compatible methods added:"
    echo "  • CreateSession(uid,pid,service,type,class,desktop,seat,vtnr,tty,display,remote,remote_user,remote_host)"
    echo "  • ReleaseSession(session_id)"
    echo "  • ActivateSession(session_id)"
    echo "  • GetSessionByPID(pid) → object_path"
    echo "  • SetIdleHint(session_id, idle)"
    echo "  • SetSessionState(session_id, state)"
    echo "  • LockSession(session_id)"
    echo "  • UnlockSession(session_id)"
    echo "  • CanGraphical() → 'yes'"
    echo ""
    echo "Interfaces registered:"
    echo "  • /org/freedesktop/login1/seat/seat0"
    echo "  • /org/freedesktop/login1/seat/auto"
    echo ""
    echo "Run: sudo ./turnstile-dbus"
else
    echo "❌ Build failed!"
    exit 1
fi
