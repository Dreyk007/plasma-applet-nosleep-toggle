// SPDX-FileCopyrightText: 2026 Dreyk
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    property bool isInhibited: false
    readonly property string currentIcon: root.isInhibited
    ? "system-suspend-inhibited"
    : "system-suspend-uninhibited"

    readonly property string checkCmd: "if systemctl --user is-active --quiet kde-nosleep-toggle.service; then echo 'ACTIVE'; else echo 'INACTIVE'; fi"

    readonly property string toggleCmd: "if systemctl --user is-active --quiet kde-nosleep-toggle.service; then systemctl --user stop kde-nosleep-toggle.service; echo 'INACTIVE'; else systemctl --user reset-failed kde-nosleep-toggle.service 2>/dev/null; systemd-run --user --unit=kde-nosleep-toggle --collect kde-inhibit --power sleep infinity >/dev/null 2>&1; echo 'ACTIVE'; fi"

    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.icon: root.currentIcon

    toolTipMainText: root.isInhibited
    ? "Sleep: LOCKED"
    : "Sleep: Allowed (Auto)"
    toolTipSubText: root.isInhibited
    ? "kde-inhibit --power is active (PC won't sleep).\nScreen turns off by standard timeout.\nLeft click — allow sleep."
    : "Standard power management mode.\nLeft click — block sleep only."

    switchWidth: Kirigami.Units.gridUnit * 100
        switchHeight: Kirigami.Units.gridUnit * 100
            preferredRepresentation: compactRepresentation

            Plasmoid.onActivated: root.toggleInhibit()

            Plasma5Support.DataSource {
                id: executable
                engine: "executable"
                connectedSources: []
                onNewData: function(sourceName, data) {
                    var out = (data["stdout"] || "").trim()
                    if (out === "ACTIVE") {
                        root.isInhibited = true
                    } else if (out === "INACTIVE") {
                        root.isInhibited = false
                    }
                    disconnectSource(sourceName)
                }
            }

            Timer {
                id: debounceTimer
                interval: 300
                repeat: false
            }

            function checkStatus() {
                executable.connectSource(root.checkCmd)
            }

            function toggleInhibit() {
                if (debounceTimer.running) {
                    return
                }
                debounceTimer.start()
                executable.connectSource(root.toggleCmd)
            }

            Timer {
                interval: 3000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: root.checkStatus()
            }

            Component {
                id: iconDelegate

                Kirigami.Icon {
                    id: trayIcon
                    anchors.fill: parent
                    implicitWidth: Kirigami.Units.iconSizes.smallMedium
                    implicitHeight: Kirigami.Units.iconSizes.smallMedium
                    source: root.currentIcon
                    active: mouseArea.containsMouse
                    opacity: root.isInhibited ? 1.0 : (mouseArea.containsMouse ? 0.7 : 0.4)

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.toggleInhibit()
                    }
                }
            }

            compactRepresentation: iconDelegate
            fullRepresentation: iconDelegate
}
