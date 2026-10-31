import qs.styles
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Item {
    id: root
    property string currentLayout: ""

    function setLayout(name) {
        currentLayout = (name.match(/\(([A-Za-z]{2,3})\)/)?.[1] ?? name.slice(0, 2)).toLowerCase()
    }

    implicitWidth: Size.groupWidth / 2
    implicitHeight: Size.groupHeight

    Process {
        running: true
        command: ["hyprctl", "devices", "-j"]
    
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const keyboard = JSON.parse(text).keyboards.find(k => k.main)
                    if (keyboard)
                        root.setLayout(keyboard.active_keymap)
                } catch (e) {
                        console.warn("keyboard layout: failed to read hyprctl output:", e)
                }
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout")
                root.setLayout(event.data.split(",").slice(1).join(","))
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        MaterialIcon {
            topPadding: 2
            text: "keyboard"
        }

        BodyText {
            text: root.currentLayout
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}