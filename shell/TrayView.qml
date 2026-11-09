import QtQuick

// Die Pille rechts: Netzwerk, Ton, Uhrzeit und Datum.
GlassPanel {
    id: tray

    property string timeText: "00:00"
    property string dateText: ""
    property url iconDir

    signal clicked()

    height: theme.barHeight
    width: row.implicitWidth + 30
    radius: height / 2

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 12

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 9
            Repeater {
                model: ["network", "volume"]
                Image {
                    required property string modelData
                    width: 17
                    height: 17
                    sourceSize.width: 34
                    sourceSize.height: 34
                    source: tray.iconDir + modelData + ".svg"
                    opacity: 0.82
                }
            }
        }

        Rectangle {
            width: 1
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            color: Qt.rgba(1, 1, 1, 0.12)
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Text {
                anchors.right: parent.right
                text: tray.timeText
                color: tray.theme.text
                font.family: tray.theme.fontDisplay
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
            Text {
                anchors.right: parent.right
                text: tray.dateText
                color: tray.theme.textDim
                font.family: tray.theme.fontText
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: tray.clicked()
    }
}
