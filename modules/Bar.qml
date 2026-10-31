import qs.styles
import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    readonly property real sideMargin: Size.base * 1.2
    readonly property int barHeight: 50

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: root.barHeight
            visible: !kino.barOpen
            color: Color.bg

            Item {
                anchors.fill: parent

                RowLayout {
                    anchors {
                        left: parent.left
                        leftMargin: root.sideMargin
                        verticalCenter: parent.verticalCenter
                    }

                    AppSearch {}
                    ActiveWindow {}
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    System {}
                    MediaPlayer { id: media }
                    Workspaces {}
                    DateTime {}
                    Item { Layout.preferredWidth: 8 }
                    XkbLayout {}
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    anchors {
                        right: parent.right
                        rightMargin: root.sideMargin
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 15

                    Tools {}
                    Volume {}
                }
            }

            MediaPopup { target: media }
        }
    }

    ScreenCorner {}
}