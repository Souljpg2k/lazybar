import qs.styles
import qs.services
import QtQuick
import Quickshell

Rectangle {
    id: root
    implicitHeight: Size.groupHeight
    implicitWidth: Size.groupWidth
    radius: Size.xs -2
    color: Color.onbg
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            mediaHoverBar = true
            kino.mediaOpen = true
        }
        onExited: mediaHoverBar = false
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onWheel: wheel => AudioService.changeVolume(Math.sign(wheel.angleDelta.y) * 0.05)
    }

    Row {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 8
            rightMargin: 8
        }
        spacing: 8

        Rectangle {
            implicitHeight: Size.base * 1.25
            implicitWidth: Size.base * 1.25
            radius: Size.base
            color: Color.overlay

            MaterialIcon {
                anchors.centerIn: parent
                text: MprisService.player ? (MprisService.player.isPlaying ? "pause" : "play_arrow") : "music_note"
                font.pixelSize: MprisService.player ? Size.base + 2 : Size.base - 2
                color: Color.onbg
                opacity: MprisService.player?.canTogglePlaying ? 1 : 0.4
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: MprisService.player?.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: MprisService.togglePlaying()
            }
        }

        BodyText {
            anchors.verticalCenter: parent.verticalCenter
            text: [MprisService.player?.trackArtist, MprisService.player?.trackTitle].filter(Boolean).join(" - ") || "No media"
            font.pixelSize: Size.base - 2
            width: parent.width - Size.base * 1.25 - 8
            elide: Text.ElideRight
        }
    }
}
