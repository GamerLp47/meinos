import QtQuick

// Glasfläche: weicher Schatten, getönter Körper, helle Kante oben, dunkle Kante unten.
// Kommt ohne Shader aus, damit es auch in der VM läuft.
Item {
    id: g

    property var theme
    property real radius: height / 2
    property bool shadow: true
    default property alias content: inner.data

    // Schatten aus mehreren sehr durchsichtigen Lagen
    Repeater {
        model: g.shadow ? 5 : 0
        Rectangle {
            required property int index
            x: -(index + 1) * 1.5
            y: -(index + 1) * 1.5 + 4
            width: g.width + (index + 1) * 3
            height: g.height + (index + 1) * 3
            radius: g.radius + (index + 1) * 1.5
            color: Qt.rgba(0, 0, 0, 0.055)
        }
    }

    // Körper
    Rectangle {
        anchors.fill: parent
        radius: g.radius
        color: g.theme.glassTint
        border.width: 1
        border.color: g.theme.glassBorder
    }

    // Lichtschimmer von oben
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: g.radius - 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.075) }
            GradientStop { position: 0.55; color: Qt.rgba(1, 1, 1, 0.0) }
        }
    }

    // Helle Kante oben
    Item {
        width: g.width
        height: Math.min(g.radius, g.height / 2)
        clip: true
        Rectangle {
            width: g.width
            height: g.height
            radius: g.radius
            color: "transparent"
            border.width: 1
            border.color: g.theme.glassHighlight
        }
    }

    // Dunkle Kante unten
    Item {
        id: lowClip
        width: g.width
        height: Math.min(g.radius, g.height / 2)
        y: g.height - height
        clip: true
        Rectangle {
            width: g.width
            height: g.height
            y: -lowClip.y
            radius: g.radius
            color: "transparent"
            border.width: 1
            border.color: g.theme.glassLowlight
        }
    }

    Item {
        id: inner
        anchors.fill: parent
    }
}
