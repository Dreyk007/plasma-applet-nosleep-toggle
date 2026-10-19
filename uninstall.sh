# SPDX-FileCopyrightText: 2026 Dreyk
# SPDX-License-Identifier: GPL-3.0-or-later

#!/usr/bin/env bash
set -e

APPLET_ID="org.kde.plasma.nosleeptoggle"

echo "Stopping active sleep inhibition service (if running)..."
systemctl --user stop kde-nosleep-toggle.service 2>/dev/null || true

echo "Removing ${APPLET_ID}..."
kpackagetool6 --type Plasma/Applet --remove "${APPLET_ID}" 2>/dev/null || \
    rm -rf "${HOME}/.local/share/plasma/plasmoids/${APPLET_ID}"

echo "Clearing Plasma QML cache..."
rm -rf "${HOME}/.cache/plasmashell/qmlcache/"* 2>/dev/null || true

echo "Restarting plasmashell..."
systemctl --user restart plasma-plasmashell.service

echo "Done! ${APPLET_ID} has been uninstalled."
