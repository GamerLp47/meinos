import QtQuick

// Der Starter: Suchfeld, Raster mit Programmen, unten Abmelden, Neustart, Ausschalten.
GlassPanel {
    id: lv

    // Liste aus { name, sub, icon, ref }
    property var entries: []
    property url iconDir
    property string query: ""
    readonly property var filtered: filterEntries(entries, query)

    signal activated(var entry)
    signal closeRequested()
    signal powerRequested(string action)

    width: 620
    height: 452
    radius: 24

    function reset() {
        search.text = ""
        grid.currentIndex = 0
        search.forceActiveFocus()
    }

    function filterEntries(list, q) {
        var needle = q.trim().toLowerCase()
        var out = []
        for (var i = 0; i < list.length; i++) {
            var e = list[i]
            var name = e.name.toLowerCase()
            var sub = (e.sub || "").toLowerCase()
            if (needle.length === 0) {
                out.push({ e: e, rank: 1, name: name })
            } else if (name.indexOf(needle) === 0) {
                out.push({ e: e, rank: 0, name: name })
            } else if (name.indexOf(needle) > 0) {
                out.push({ e: e, rank: 1, name: name })
            } else if (sub.indexOf(needle) >= 0) {
                out.push({ e: e, rank: 2, name: name })
            }
        }
        out.sort(function (a, b) {
            if (a.rank !== b.rank)
                return a.rank - b.rank
            return a.name < b.name ? -1 : (a.name > b.name ? 1 : 0)
        })
        var res = []
        for (var j = 0; j < out.length; j++)
            res.push(out[j].e)
        return res
    }

    function activateCurrent() {
        if (grid.currentIndex >= 0 && grid.currentIndex < filtered.length)
            lv.activated(filtered[grid.currentIndex])
    }

    // Klicks auf das Feld selbst sollen den Starter nicht schließen
    MouseArea {
        anchors.fill: parent
    }

    // Suchfeld
    Rectangle {
        id: searchBox
        x: 18
        y: 18
        width: parent.width - 36
        height: 42
        radius: 21
        color: Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
        border.color: search.activeFocus ? Qt.rgba(1, 1, 1, 0.22) : Qt.rgba(1, 1, 1, 0.10)

        Image {
            id: glass
            x: 14
            anchors.verticalCenter: parent.verticalCenter
            width: 17
            height: 17
            sourceSize.width: 34
            sourceSize.height: 34
            source: lv.iconDir + "search.svg"
            opacity: 0.6
        }

        TextInput {
            id: search
            anchors.left: glass.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            color: lv.theme.text
            selectionColor: lv.theme.accent
            selectedTextColor: "white"
            font.family: lv.theme.fontText
            font.pixelSize: 14
            font.weight: Font.Medium
            clip: true
            focus: true
            onTextChanged: {
                lv.query = text
                grid.currentIndex = 0
            }
            onAccepted: lv.activateCurrent()
            Keys.onEscapePressed: lv.closeRequested()
            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Down) {
                    grid.moveCurrentIndexDown()
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    grid.moveCurrentIndexUp()
                    event.accepted = true
                } else if (event.key === Qt.Key_Right && cursorPosition === text.length) {
                    grid.moveCurrentIndexRight()
                    event.accepted = true
                } else if (event.key === Qt.Key_Left && cursorPosition === 0) {
                    grid.moveCurrentIndexLeft()
                    event.accepted = true
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: search.text.length === 0
                text: "Programme suchen"
                color: lv.theme.textFaint
                font: search.font
            }
        }
    }

    // Raster
    GridView {
        id: grid
        x: 18
        y: searchBox.y + searchBox.height + 14
        width: parent.width - 36
        height: footer.y - y - 10
        clip: true
        cellWidth: Math.floor(width / 6)
        cellHeight: 98
        boundsBehavior: Flickable.StopAtBounds
        model: lv.filtered
        currentIndex: 0
        highlightMoveDuration: 0

        delegate: Item {
            id: cell
            required property var modelData
            required property int index
            width: grid.cellWidth
            height: grid.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 3
                radius: 16
                color: Qt.rgba(1, 1, 1, cell.index === grid.currentIndex ? 0.10 : (cellArea.containsMouse ? 0.05 : 0.0))
                border.width: cell.index === grid.currentIndex ? 1 : 0
                border.color: Qt.rgba(1, 1, 1, 0.14)
            }

            AppIcon {
                id: ic
                y: 13
                anchors.horizontalCenter: parent.horizontalCenter
                theme: lv.theme
                size: 46
                source: cell.modelData.icon
                label: cell.modelData.name
                enabled: false
            }

            Text {
                y: 66
                x: 6
                width: parent.width - 12
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                text: cell.modelData.name
                color: lv.theme.text
                font.family: lv.theme.fontText
                font.pixelSize: 11
                font.weight: Font.Medium
            }

            MouseArea {
                id: cellArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    grid.currentIndex = cell.index
                    lv.activated(cell.modelData)
                }
            }
        }
    }

    Text {
        anchors.centerIn: grid
        visible: lv.filtered.length === 0
        text: lv.entries.length === 0 ? "Keine Programme gefunden" : "Kein Treffer"
        color: lv.theme.textDim
        font.family: lv.theme.fontText
        font.pixelSize: 13
    }

    // Fußzeile
    Item {
        id: footer
        x: 18
        y: parent.height - 54
        width: parent.width - 36
        height: 40

        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(1, 1, 1, 0.08)
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 4
            text: lv.filtered.length + (lv.filtered.length === 1 ? " Programm" : " Programme")
            color: lv.theme.textFaint
            font.family: lv.theme.fontText
            font.pixelSize: 11
            font.weight: Font.Medium
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 4
            spacing: 6

            Repeater {
                model: [
                    { action: "logout", icon: "logout", tip: "Abmelden" },
                    { action: "reboot", icon: "restart", tip: "Neustart" },
                    { action: "poweroff", icon: "power", tip: "Ausschalten" }
                ]
                Rectangle {
                    id: pb
                    required property var modelData
                    width: pbRow.implicitWidth + 22
                    height: 30
                    radius: 15
                    color: pbArea.containsMouse ? lv.theme.tileHover : lv.theme.tile
                    border.width: 1
                    border.color: lv.theme.tileBorder
                    scale: pbArea.pressed ? 0.94 : 1.0

                    Row {
                        id: pbRow
                        anchors.centerIn: parent
                        spacing: 6
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            sourceSize.width: 28
                            sourceSize.height: 28
                            source: lv.iconDir + pb.modelData.icon + ".svg"
                            opacity: 0.85
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: pb.modelData.tip
                            color: lv.theme.text
                            font.family: lv.theme.fontText
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }
                    }

                    MouseArea {
                        id: pbArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: lv.powerRequested(pb.modelData.action)
                    }
                }
            }
        }
    }
}
