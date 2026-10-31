import qs.styles
import qs.services
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

Scope {
    id: root
    property Item target
    readonly property var player: MprisService.player
    readonly property bool hovered: mediaHoverBar || popupHover.hovered
    readonly property int pad: 10
    property real progress: kino.mediaOpen ? 1 : 0

    readonly property var controls: [
        {
            icon: "skip_previous",
            enabled: player?.canGoPrevious ?? false,
            action: () => player?.previous()
        },
        {
            icon: player?.isPlaying ? "pause" : "play_arrow",
            enabled: player?.canTogglePlaying ?? false,
            action: () => player?.togglePlaying()
        },
        {
            icon: "skip_next",
            enabled: player?.canGoNext ?? false,
            action: () => player?.next()
        }
    ]

    onHoveredChanged: hovered ? closeTimer.stop() : closeTimer.restart()

    Behavior on progress {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Timer {
        id: closeTimer
        interval: 200
        onTriggered: kino.mediaOpen = false
    }

    PopupWindow {
        anchor.item: root.target
        anchor.rect.x: root.target.width / 2 - implicitWidth / 2
        anchor.rect.y: root.target.height + (bar.implicitHeight - root.target.height) / 2 - 2
        implicitWidth: card.implicitWidth + root.pad * 2
        implicitHeight: card.implicitHeight + root.pad * 2
        visible: kino.mediaOpen || root.progress > 0
        color: "transparent"

        Item {
            id: wrapper
            anchors.fill: parent
            opacity: root.progress

            transform: [
                Translate { y: -12 * (1 - root.progress) },
                Scale {
                    origin.x: wrapper.width / 2
                    origin.y: 0
                    xScale: 0.95 + 0.05 * root.progress
                    yScale: xScale
                }
            ]

            HoverHandler { id: popupHover }

            RectangularShadow {
                anchors.fill: card
                blur: 10
                radius: card.radius
                color: "#cf000000"
            }

            ClippingRectangle {
                id: card
                anchors.centerIn: parent
                implicitWidth: 300
                implicitHeight: 120
                radius: Size.base
                color: Color.bg

                RowLayout {
                    anchors.fill: parent

                    ClippingRectangle {
                        implicitWidth: 100
                        implicitHeight: 100
                        Layout.margins: root.pad
                        radius: Size.base
                        color: Color.onbg

                        Image {
                            anchors.fill: parent
                            source: root.player?.trackArtUrl || ""
                            sourceSize: Qt.size(width, height)
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: root.pad
                        Layout.rightMargin: root.pad
                        spacing: -2

                        BodyText {
                            Layout.fillWidth: true
                            text: root.player?.trackArtist || "Unknown Artist"
                            font.pixelSize: Size.base - 1
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        BodyText {
                            Layout.fillWidth: true
                            text: root.player?.trackTitle || "Unknown Title"
                            font.pixelSize: Size.base - 2
                            opacity: 0.9
                            elide: Text.ElideRight
                        }

                        BodyText {
                            Layout.topMargin: 4
                            visible: root.player?.positionSupported ?? false
                            text: MprisService.fmt(root.player?.position) + " / " + MprisService.fmt(root.player?.length)
                            font.pixelSize: Size.base - 3
                            font.features: { "tnum": 1 }
                            opacity: 0.8
                        }

                        RowLayout {
                            Layout.topMargin: root.pad
                            spacing: 12

                            Repeater {
                                model: root.controls

                                delegate: Rectangle {
                                    id: button
                                    required property var modelData

                                    implicitWidth: Size.base + 10
                                    implicitHeight: Size.base + 10
                                    radius: Size.xs
                                    color: Color.onbg
                                    opacity: modelData.enabled ? 1 : 0.4

                                    Behavior on opacity {
                                        NumberAnimation { duration: 150 }
                                    }

                                    MaterialIcon {
                                        anchors.centerIn: parent
                                        text: button.modelData.icon
                                        font.pixelSize: Size.base + 2
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        enabled: button.modelData.enabled
                                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: button.modelData.action()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}