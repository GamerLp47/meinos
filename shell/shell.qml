import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

// meinos: Hintergrund, Leiste und Starter.
// Die Teile selbst liegen in eigenen Dateien; hier wird nur verdrahtet.
ShellRoot {
    id: root

    property bool launcherOpen: false

    // Programme, die fest in der Leiste stehen (nur installierte werden gezeigt)
    readonly property var pinned: ["vivaldi-stable", "discord", "steam", "cockos-reaper", "spotify", "thunar", "foot"]

    readonly property var allApps: collectApps(DesktopEntries.applications.values)
    readonly property var dockApps: collectDock(allApps, ToplevelManager.toplevels.values)

    readonly property url assetDir: Qt.resolvedUrl("assets/")

    onLauncherOpenChanged: {
        if (launcherOpen)
            Qt.callLater(launcher.reset)
    }

    function norm(s) {
        var t = ("" + (s || "")).toLowerCase()
        if (t.length > 8 && t.lastIndexOf(".desktop") === t.length - 8)
            t = t.substring(0, t.length - 8)
        return t
    }

    function iconFor(name) {
        if (!name || name.length === 0)
            return ""
        if (name.charAt(0) === "/")
            return "file://" + name
        return Quickshell.iconPath(name, true)
    }

    function collectApps(list) {
        var out = []
        for (var i = 0; i < list.length; i++) {
            var e = list[i]
            if (!e || e.noDisplay)
                continue
            out.push({
                id: norm(e.id),
                name: e.name,
                sub: e.genericName || e.comment || "",
                icon: iconFor(e.icon),
                ref: e
            })
        }
        return out
    }

    function findApp(apps, id) {
        var n = norm(id)
        if (n.length === 0)
            return null
        for (var i = 0; i < apps.length; i++) {
            if (apps[i].id === n)
                return apps[i]
        }
        // z. B. "org.xfce.thunar" passt auf "thunar"
        var tail = n.substring(n.lastIndexOf(".") + 1)
        for (var j = 0; j < apps.length; j++) {
            if (apps[j].id === tail || apps[j].id.substring(apps[j].id.lastIndexOf(".") + 1) === n)
                return apps[j]
        }
        return null
    }

    function collectDock(apps, tops) {
        var out = []
        var byId = {}
        var i

        for (i = 0; i < pinned.length; i++) {
            var a = findApp(apps, pinned[i])
            if (a && !byId[a.id]) {
                var item = { id: a.id, name: a.name, icon: a.icon, ref: a.ref, top: null, running: false, active: false }
                byId[a.id] = item
                out.push(item)
            }
        }

        for (i = 0; i < tops.length; i++) {
            var t = tops[i]
            if (!t)
                continue
            var app = findApp(apps, t.appId)
            var key = app ? app.id : norm(t.appId)
            if (key.length === 0)
                continue
            var it = byId[key]
            if (!it) {
                it = {
                    id: key,
                    name: app ? app.name : t.appId,
                    icon: app ? app.icon : iconFor(t.appId),
                    ref: app ? app.ref : null,
                    top: null, running: false, active: false
                }
                byId[key] = it
                out.push(it)
            }
            it.running = true
            if (!it.top || t.activated)
                it.top = t
            if (t.activated)
                it.active = true
        }
        return out
    }

    function dockClicked(index) {
        var it = dockApps[index]
        if (!it)
            return
        if (it.top)
            it.top.activate()
        else if (it.ref)
            it.ref.execute()
    }

    function power(action) {
        if (action === "poweroff")
            runner.command = ["systemctl", "poweroff"]
        else if (action === "reboot")
            runner.command = ["systemctl", "reboot"]
        else
            runner.command = ["hyprctl", "dispatch", "exit"]
        runner.running = true
    }

    Theme {
        id: ui
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Process {
        id: runner
    }

    // Erlaubt später ein Tastenkürzel: quickshell ipc call launcher toggle
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            root.launcherOpen = !root.launcherOpen
        }
    }

    // Hintergrundbild
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            color: "#0c0c12"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "meinos-wallpaper"

            Wallpaper {
                anchors.fill: parent
            }
        }
    }

    // Leiste
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
            implicitHeight: ui.barHeight + ui.barMargin * 2
            color: "transparent"
            WlrLayershell.namespace: "meinos-bar"

            DockView {
                theme: ui
                apps: root.dockApps
                logoSource: root.assetDir + "logo.png"
                launcherOpen: root.launcherOpen
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: ui.barMargin
                onStartClicked: root.launcherOpen = !root.launcherOpen
                onAppClicked: function (index) {
                    root.dockClicked(index)
                }
            }

            TrayView {
                theme: ui
                iconDir: root.assetDir + "icons/"
                timeText: Qt.formatDateTime(clock.date, "HH:mm")
                dateText: clock.date.toLocaleDateString(Qt.locale("de_DE"), "ddd d. MMM")
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: ui.barMargin
            }
        }
    }

    // Starter (liegt über allem, schließt bei Klick daneben oder Esc)
    PanelWindow {
        id: launcherWin
        visible: root.launcherOpen
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.namespace: "meinos-launcher"

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.22)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.launcherOpen = false
        }

        LauncherView {
            id: launcher
            theme: ui
            entries: root.allApps
            iconDir: root.assetDir + "icons/"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ui.barHeight + ui.barMargin * 2 + 6
            onCloseRequested: root.launcherOpen = false
            onActivated: function (entry) {
                root.launcherOpen = false
                if (entry && entry.ref)
                    entry.ref.execute()
            }
            onPowerRequested: function (action) {
                root.launcherOpen = false
                root.power(action)
            }
        }
    }
}
