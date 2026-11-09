import QtQuick

// Alle Farben, Größen und Schriften an einer Stelle.
// Später steuern die Einstellungen diese Werte (Glasregler, Akzentfarbe, Tempo).
QtObject {
    // Glas
    property real glassAlpha: 0.58
    property color glassTint: Qt.rgba(0.075, 0.072, 0.098, glassAlpha)
    property color glassBorder: Qt.rgba(1, 1, 1, 0.10)
    property color glassHighlight: Qt.rgba(1, 1, 1, 0.26)
    property color glassLowlight: Qt.rgba(0, 0, 0, 0.30)

    // Text
    property color text: Qt.rgba(1, 1, 1, 0.94)
    property color textDim: Qt.rgba(1, 1, 1, 0.60)
    property color textFaint: Qt.rgba(1, 1, 1, 0.36)

    // Flächen auf dem Glas
    property color tile: Qt.rgba(1, 1, 1, 0.07)
    property color tileHover: Qt.rgba(1, 1, 1, 0.15)
    property color tileBorder: Qt.rgba(1, 1, 1, 0.10)

    // Akzent (vorerst Weinrot, wird später frei wählbar)
    property color accent: "#c0292b"

    // Schriften
    property string fontText: "Manrope"
    property string fontDisplay: "Sora"

    // Maße
    property int barHeight: 38
    property int barMargin: 8
    property int iconTile: 26

    // Tempo der Bewegungen (1 = normal, 0 = aus)
    property real motion: 1.0
}
