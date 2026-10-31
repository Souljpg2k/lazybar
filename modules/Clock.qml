import qs.styles
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    id: root
    readonly property int pad: 20
    property real progress: kino.clockOpen ? 1 : 0

    Behavior on progress {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    Variants {
        model: Quickshell.screens

        LazyLoader {
            id: loader
            required property var modelData
            active: kino.clockOpen || root.progress > 0

            PanelWindow {
                screen: loader.modelData
                anchors {
                    right: true
                    bottom: true
                }
                margins {
                    right: 50 - root.pad
                    bottom: 30 + 20 * root.progress - root.pad
                }
                implicitWidth: content.implicitWidth + root.pad * 2
                implicitHeight: content.implicitHeight + root.pad * 2
                color: "transparent"
                mask: Region {}
                WlrLayershell.layer: WlrLayer.Bottom

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                ColumnLayout {
                    id: content
                    anchors.centerIn: parent
                    spacing: -13
                    opacity: root.progress

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#d9000000"
                        shadowOpacity: 0.6
                        shadowBlur: 0.8
                    }

                    BodyText {
                        text: Qt.formatDateTime(clock.date, "HH:mm AP")
                        font.pixelSize: Size.base * 5
                        font.features: { "tnum": 1 }
                        font.bold: true
                    }

                    BodyText {
                        Layout.alignment: Qt.AlignRight
                        text: Qt.formatDateTime(clock.date, "ddd, dd/MM yyyy")
                        font.pixelSize: Size.base
                        font.features: { "tnum": 1 }
                        font.bold: true
                    }
                }
            }
        }
    }
}