pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool dark: true

    readonly property color base:     dark ? "#1e1e2e" : "#eff1f5"
    readonly property color onbg:     dark ? "#181825" : "#e6e9ef"
    readonly property color bg:       dark ? "#11111b" : "#dce0e8"
    readonly property color fg:       dark ? "#cdd6f4" : "#4c4f69"
    readonly property color red:      dark ? "#f38ba8" : "#d20f39"
    readonly property color lavender: dark ? "#b4befe" : "#7287fd"
    readonly property color overlay:  dark ? "#6c7086" : "#9ca0b0"
    readonly property color surface:  dark ? "#45475a" : "#bcc0cc"

    function setDark(v) {
        dark = v
        file.setText(v ? "true" : "false")
    }

    function toggle() { setDark(!dark) }

    FileView {
        id: file
        path: Quickshell.shellPath("styles/dark.txt")
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.dark = text().trim() !== "false"
    }
}