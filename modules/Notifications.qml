import qs.styles
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Scope {
    id: root
    property bool notifOpen: false
    readonly property int count: server.trackedNotifications.values.length
    
    readonly property var panel: ({
        width: 300,
        edge: 20,
        top: 60,
        pad: 10,
        icon: 80,
        max: 4,
        anim: 300,
        timeout: 5000
    })

    NotificationServer {
        id: server
        actionIconsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => n.tracked = true
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }
        margins.top: root.panel.top - root.panel.edge
        implicitWidth: root.panel.width + root.panel.edge * 2
        implicitHeight: list.implicitHeight + 60
        exclusionMode: ExclusionMode.Ignore
        visible: root.count > 0 && !root.notifOpen
        color: "transparent"
        mask: Region { item: list }

        Column {
            id: list
            anchors {
                top: parent.top
                right: parent.right
                topMargin: root.panel.edge
                rightMargin: root.panel.edge
            }
            width: root.panel.width
            spacing: 8

            move: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                visible: root.count > root.panel.max
                width: list.width
                height: 26
                radius: Size.base
                color: Color.bg

                BodyText {
                    anchors.centerIn: parent
                    text: "+" + Math.max(0, root.count - root.panel.max) + " more"
                }
            }

            Repeater {
                model: server.trackedNotifications

                delegate: Item {
                    id: item

                    required property var modelData
                    required property int index
                    property bool shown: false
                    property bool expired: false

                    visible: index >= root.count - root.panel.max
                    width: list.width
                    height: container.height

                    Component.onCompleted: shown = true

                    function close(byTimeout = false) {
                        expired = byTimeout
                        shown = false
                        closeTimer.start()
                    }

                    Timer {
                        running: !area.containsMouse && item.visible
                        interval: root.panel.timeout
                        onTriggered: item.close(true)
                    }

                    Timer {
                        id: closeTimer
                        interval: root.panel.anim
                        onTriggered: item.expired ? item.modelData.expire() : item.modelData.dismiss()
                    }

                    RectangularShadow {
                        anchors.fill: container
                        radius: container.radius
                        blur: 10
                        color: Qt.rgba(0, 0, 0, 0.7)
                        opacity: container.opacity
                    }

                    Rectangle {
                        id: container
                        width: parent.width
                        implicitHeight: content.implicitHeight + root.panel.pad * 2
                        radius: Size.base
                        color: Color.bg
                        border.width: item.modelData.urgency === NotificationUrgency.Critical ? 1 : 0
                        border.color: Color.red
                        x: item.shown ? 0 : root.panel.edge
                        opacity: item.shown ? 1 : 0

                        Behavior on x {
                            NumberAnimation { duration: root.panel.anim; easing.type: Easing.OutCubic }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: root.panel.anim; easing.type: Easing.OutCubic }
                        }

                        RowLayout {
                            id: content
                            anchors.fill: parent
                            anchors.margins: root.panel.pad
                            spacing: root.panel.pad

                            Image {
                                readonly property string src: {
                                    if (item.modelData.image)
                                        return item.modelData.image
                                    if (item.modelData.appIcon)
                                        return Quickshell.iconPath(item.modelData.appIcon, true)
                                    return ""
                                }

                                Layout.preferredWidth: root.panel.icon
                                Layout.preferredHeight: root.panel.icon
                                visible: src !== ""
                                source: src
                                fillMode: Image.PreserveAspectFit
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                BodyText {
                                    Layout.fillWidth: true
                                    text: item.modelData.summary
                                    color: Color.lavender
                                    elide: Text.ElideRight
                                }

                                BodyText {
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                    text: item.modelData.body
                                    font.pixelSize: Size.sm
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 5
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            id: area
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: item.close()
                        }
                    }
                }
            }
        }
    }
}