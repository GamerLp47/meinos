import QtQuick

// Ein Programm-Symbol in einer abgerundeten Kachel.
// Federt beim Überfahren leicht auf und gibt beim Drücken sofort nach.
Item {
    id: a

    property var theme
    property string source: ""
    property string label: ""
    property real size: 36
    property bool running: false
    property bool active: false
    property bool selected: false
    property bool showTile: true
    readonly property bool hovered: area.containsMouse

    signal clicked()

    width: size
    height: size

    Item {
        id: body
        anchors.fill: parent
        scale: area.pressed ? 0.90 : (area.containsMouse ? 1.10 : 1.0)
        Behavior on scale {
            enabled: a.theme.motion > 0
            SpringAnimation { spring: 5.5; damping: 0.32; mass: 0.5 / Math.max(0.2, a.theme.motion) }
        }

        Rectangle {
            anchors.fill: parent
            visible: a.showTile
            radius: a.size * 0.29
            color: (area.containsMouse || a.selected) ? a.theme.tileHover : a.theme.tile
            border.width: 1
            border.color: a.selected ? Qt.rgba(1, 1, 1, 0.30) : a.theme.tileBorder
        }

        Image {
            id: img
            anchors.centerIn: parent
            width: Math.round(a.size * (a.showTile ? 0.68 : 1.0))
            height: width
            sourceSize.width: width * 2
            sourceSize.height: height * 2
            source: a.source
            smooth: true
            visible: status === Image.Ready
        }

        Text {
            anchors.centerIn: parent
            visible: img.status !== Image.Ready
            text: a.label.length > 0 ? a.label.charAt(0).toUpperCase() : "?"
            color: a.theme.text
            font.family: a.theme.fontDisplay
            font.pixelSize: a.size * 0.42
            font.weight: Font.DemiBold
        }
    }

    // Punkt unter laufenden Programmen
    Rectangle {
        visible: a.running
        anchors.horizontalCenter: parent.horizontalCenter
        y: a.size + 2
        width: a.active ? 12 : 4
        height: 3
        radius: 1.5
        color: a.active ? a.theme.accent : a.theme.textDim
        Behavior on width {
            enabled: a.theme.motion > 0
            NumberAnimation { duration: 180 / Math.max(0.2, a.theme.motion); easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: a.clicked()
    }
}
