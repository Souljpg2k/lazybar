import qs.styles
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    readonly property string dir: Quickshell.env("HOME") + "/Pictures/Screenshots"
    property bool sunsetActive: false

    readonly property var tools: [
        {
            icon: "screenshot_region",
            action: mouse => Quickshell.execDetached(["hyprshot", "-m", mouse.button === Qt.LeftButton ? "region" : "window", "-o", dir])
        },
        {
            icon: "colorize",
            action: () => Quickshell.execDetached(["hyprpicker", "-a"])
        },
        {
            icon: "assignment",
            action: () => Quickshell.execDetached(["sh", "-c", "cliphist list | rofi -dmenu -p '> ' -no-show-icons -display-columns 2 | cliphist decode | wl-copy"])
        },
        {
            icon: sunsetActive ? "nightlight" : "light_mode",
            action: () => toggleSunset()
        }
    ]

    function toggleSunset() {
        sunsetActive = !sunsetActive
        Quickshell.execDetached(["hyprctl", "hyprsunset", sunsetActive ? "temperature" : "identity", ...(sunsetActive ? ["4000"] : [])])
    }

    implicitHeight: Size.groupHeight
    implicitWidth: content.implicitWidth * 1.2

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: root.tools

            delegate: MaterialIcon {
                id: tool
                required property var modelData

                text: modelData.icon

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => tool.modelData.action(mouse)
                }
            }
        }
    }
}