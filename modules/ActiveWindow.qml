import qs.styles
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    readonly property var active: ToplevelManager.activeToplevel

    implicitHeight: Size.groupHeight
    implicitWidth: Size.groupWidth / 2

    Column {
        anchors.verticalCenter: parent.verticalCenter
        spacing: -5

        BodyText {
            width: root.implicitWidth
            text: root.active?.appId || "Desktop"
            font.pixelSize: Size.sm
            font.bold: true
            opacity: 0.5
            elide: Text.ElideRight
        }

        BodyText {
            width: root.implicitWidth
            text: root.active?.title || "Workspace " + (Hyprland.focusedWorkspace?.id ?? "")
            font.pixelSize: Size.base - 2
            elide: Text.ElideRight
        }
    }
}