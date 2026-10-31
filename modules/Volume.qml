import qs.styles
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    implicitHeight: Size.groupHeight
    implicitWidth: content.implicitWidth

    TextMetrics {
        id: metrics
        font: volText.font
        text: "100"
    }

    RowLayout {
        id: content
        anchors.verticalCenter: parent.verticalCenter

        MaterialIcon {
            text: AudioService.muted ? "graphic_eq_off" : "graphic_eq"
        }

        BodyText {
            id: volText
            Layout.preferredWidth: metrics.advanceWidth
            text: AudioService.volumePercent
            font.pixelSize: Size.base - 3
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: AudioService.toggleMute()
        onWheel: wheel => AudioService.changeVolume(Math.sign(wheel.angleDelta.y) * 0.05)
    }
}