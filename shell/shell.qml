import Quickshell
import Quickshell.Wayland
import QtQuick

// Erste Version der Leiste: Dock-Pille in der Mitte, Tray-Pille rechts.
ShellRoot {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                bottom: true
            }
            implicitHeight: 68
            color: "transparent"
            WlrLayershell.namespace: "meinos-bar"

            // Dock-Pille (Mitte)
            Rectangle {
                id: dock
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                height: 48
                width: dockRow.implicitWidth + 24
                radius: height / 2
                color: Qt.rgba(0.094, 0.090, 0.118, 0.55)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.12)

                Row {
                    id: dockRow
                    anchors.centerIn: parent
                    spacing: 8

                    // Start-Knopf
                    Rectangle {
                        width: 34; height: 34; radius: 11
                        color: Qt.rgba(1, 1, 1, 0.14)
                        border.width: 1
                        border.color: Qt.rgba(1, 1, 1, 0.2)
                        Text {
                            anchors.centerIn: parent
                            text: "JR"
                            color: "white"
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                        }
                    }

                    Rectangle {
                        width: 1; height: 24
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(1, 1, 1, 0.15)
                    }

                    // Platzhalter-Apps
                    Repeater {
                        model: [
                            { t: "V", c: "#c0292b" },
                            { t: "D", c: "#5865f2" },
                            { t: "S", c: "#1b6fa8" },
                            { t: "R", c: "#3a8f5c" },
                            { t: "M", c: "#1db954" },
                            { t: "F", c: "#c9a227" }
                        ]

                        Rectangle {
                            required property var modelData
                            width: 34; height: 34; radius: 11
                            color: modelData.c
                            scale: area.containsMouse ? 1.12 : 1.0
                            Behavior on scale {
                                SpringAnimation { spring: 4; damping: 0.3 }
                            }
                            Text {
                                anchors.centerIn: parent
                                text: modelData.t
                                color: "white"
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                            }
                            MouseArea {
                                id: area
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                        }
                    }
                }
            }

            // Tray-Pille (rechts)
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                height: 48
                width: trayRow.implicitWidth + 28
                radius: height / 2
                color: Qt.rgba(0.094, 0.090, 0.118, 0.55)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.12)

                Row {
                    id: trayRow
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "WLAN  Ton"
                        color: Qt.rgba(1, 1, 1, 0.7)
                        font.pixelSize: 12
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: Qt.formatDateTime(clock.date, "hh:mm")
                            color: "white"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }
                        Text {
                            text: Qt.formatDateTime(clock.date, "ddd d. MMM")
                            color: Qt.rgba(1, 1, 1, 0.6)
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
    }
}
