import qs.styles
import QtQuick
import Quickshell

Rectangle {
    implicitHeight: Size.groupHeight
    implicitWidth: Size.groupWidth * 1.04
    radius: Size.xs -2
    color: Color.onbg

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    BodyText {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "HH:mm AP • ddd, dd/MM")
        font.features: { "tnum": 1 }
        font.pixelSize: Size.base -2
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: kino.clockOpen = !kino.clockOpen
    }
}
