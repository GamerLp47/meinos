import QtQuick

// Die Pille in der Mitte: Start-Knopf, Trennstrich, Programme.
GlassPanel {
    id: dock

    // Liste aus { name, icon, running, active }
    property var apps: []
    property url logoSource
    property bool launcherOpen: false

    signal startClicked()
    signal appClicked(int index)

    height: theme.barHeight
    width: row.implicitWidth + 16
    radius: height / 2

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 7

        // Start-Knopf mit JR-Zeichen
        Item {
            id: start
            width: dock.theme.iconTile
            height: dock.theme.iconTile
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                source: dock.logoSource
                sourceSize.width: 144
                sourceSize.height: 144
                smooth: true
                scale: startArea.pressed ? 0.90 : (startArea.containsMouse || dock.launcherOpen ? 1.10 : 1.0)
                Behavior on scale {
                    enabled: dock.theme.motion > 0
                    SpringAnimation { spring: 5.5; damping: 0.32; mass: 0.5 / Math.max(0.2, dock.theme.motion) }
                }
            }
            MouseArea {
                id: startArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: dock.startClicked()
            }
        }

        Rectangle {
            visible: dock.apps.length > 0
            width: 1
            height: 22
            anchors.verticalCenter: parent.verticalCenter
            color: Qt.rgba(1, 1, 1, 0.14)
        }

        Repeater {
            model: dock.apps
            AppIcon {
                required property var modelData
                required property int index
                anchors.verticalCenter: parent.verticalCenter
                theme: dock.theme
                size: dock.theme.iconTile
                source: modelData.icon
                label: modelData.name
                running: modelData.running
                active: modelData.active
                onClicked: dock.appClicked(index)
            }
        }
    }
}
