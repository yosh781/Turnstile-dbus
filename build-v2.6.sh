#!/bin/bash
echo "========================================="
echo " Building turnstile-dbus v2.6.3 + seatd"
echo "========================================="
echo ""

mkdir -p obj

echo "🔨 Compiling seatd-helper.c..."
gcc -c src/seatd-helper.c -o obj/seatd-helper.o \
    $(pkg-config --cflags libseat 2>/dev/null) \
    -Wall -Wextra -O2 || exit 1

echo "🔨 Compiling turnstile-dbus-final.c..."
gcc -c src/turnstile-dbus-final.c -o obj/turnstile-dbus-final.o \
    -I/usr/include/dbus-1.0 \
    -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include \
    -I/usr/include/turnstile \
    -I/usr/include \
    $(pkg-config --cflags libseat 2>/dev/null) \
    -Wall -Wextra -O2 || exit 1

echo "🔗 Linking..."
gcc -o turnstile-dbus \
    obj/turnstile-dbus-final.o \
    obj/seatd-helper.o \
    -ldbus-1 -lseat -lturnstile-highlevel -lturnstile -lpthread || exit 1

echo ""
echo "========================================="
echo " ✅ Build successful!"
echo "========================================="
echo ""
echo "Features:"
echo "  • seatd integration (DRM fd via D-Bus)"
echo "  • KDE/Wayland session support"
echo "  • logind D-Bus API compatibility"
echo "  • CreateSession returns DRM device fd"
echo ""
echo "Binary: $(pwd)/turnstile-dbus"
echo ""
echo "Install: sudo cp turnstile-dbus /usr/sbin/turnstile-dbus"
echo "Restart: sudo dinitctl restart turnstile-dbus"
