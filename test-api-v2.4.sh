#!/bin/bash
echo "Testing turnstile-dbus v2.4.0 new features"
echo "=========================================="
echo ""

# Test SetWallMessage
echo "1. SetWallMessage:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.SetWallMessage \
  string:"System maintenance in 5 minutes"
echo ""

# Test ScheduleShutdown (10 seconds from now)
echo "2. ScheduleShutdown (poweroff in 10 seconds):"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.ScheduleShutdown \
  string:"poweroff" int64:10000000
echo ""

sleep 2

# Test CancelScheduledShutdown
echo "3. CancelScheduledShutdown:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CancelScheduledShutdown
echo ""

# Test Inhibit
echo "4. Inhibit (block shutdown for update):"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.Inhibit \
  string:"shutdown:sleep" \
  string:"Package Updater" \
  string:"System update in progress" \
  string:"block"
echo ""

# Test GetActiveSeat
echo "5. GetActiveSeat:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.GetActiveSeat
echo ""

# Test GetSession
echo "6. GetSession (list sessions first):"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.ListSessions 2>/dev/null | head -20
echo ""

# Test Can methods
echo "7. CanPowerOff:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CanPowerOff
echo ""

echo "8. CanReboot:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CanReboot
echo ""

echo "9. CanSuspend:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CanSuspend
echo ""

echo "10. CanHibernate:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CanHibernate
echo ""

echo "11. CanHybridSleep:"
dbus-send --system --print-reply \
  --dest=org.turnstile.login1 \
  /org/turnstile/login1 \
  org.turnstile.login1.Manager.CanHybridSleep
echo ""

echo "✅ All v2.4.0 tests completed!"
echo "Note: Full shutdown tests require running as root with active sessions"
