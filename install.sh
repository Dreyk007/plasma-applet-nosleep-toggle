# SPDX-FileCopyrightText: 2026 Dreyk
# SPDX-License-Identifier: GPL-3.0-or-later

#!/usr/bin/env bash
set -e

APPLET_ID="org.kde.plasma.nosleeptoggle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Removing previous installation (if any)..."
rm -rf "${HOME}/.local/share/plasma/plasmoids/${APPLET_ID}"

echo "Clearing Plasma QML cache..."
rm -rf "${HOME}/.cache/plasmashell/qmlcache/"* 2>/dev/null || true

echo "Installing ${APPLET_ID}..."
kpackagetool6 --type Plasma/Applet --install "${SCRIPT_DIR}"

echo "Restarting plasmashell..."
systemctl --user restart plasma-plasmashell.service

echo "Done! ${APPLET_ID} has been installed successfully."
