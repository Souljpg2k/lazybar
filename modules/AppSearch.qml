import qs.styles
import QtQuick
import Quickshell

Item {
    implicitHeight: Size.groupHeight
    implicitWidth: content.implicitWidth * 1.5

    NerdIcon {
        id: content
        anchors.centerIn: parent
        text: ""
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
    }
}