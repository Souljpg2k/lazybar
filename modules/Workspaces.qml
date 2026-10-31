import qs.styles
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Rectangle {
    id: root
    readonly property int wsCount: 10
    readonly property int pad: 8
    readonly property int itemSize: 26
    readonly property int indicatorSize: 22
    readonly property int animMs: 450
    readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1
    readonly property int indicatorOffset: pad + (itemSize - indicatorSize) / 2

    function focusWorkspace(id) {
        const target = Math.max(1, Math.min(wsCount, id))
        Hyprland.dispatch(Hyprland.usingLua ? "hl.dsp.focus({ workspace = " + target + " })" : "workspace " + target)
    }

    implicitHeight: Size.groupHeight
    implicitWidth: Size.groupWidth * 1.4
    radius: Size.xs - 2
    color: Color.onbg

    onActiveIdChanged: {
        indicator.fromId = indicator.toId
        indicator.toId = activeId
        settle.restart()
    }

    Timer {
        id: settle
        interval: 150
        onTriggered: indicator.fromId = indicator.toId
    }

    Rectangle {
        id: indicator
        property int fromId: root.activeId
        property int toId: root.activeId

        anchors.verticalCenter: parent.verticalCenter
        x: root.indicatorOffset + (Math.min(fromId, toId) - 1) * root.itemSize
        width: Math.abs(toId - fromId) * root.itemSize + root.indicatorSize
        height: root.indicatorSize
        radius: height / 2
        color: Color.fg

        Behavior on x {
            NumberAnimation { duration: root.animMs; easing.type: Easing.OutCubic; }
        }

        Behavior on width {
            NumberAnimation { duration: root.animMs; easing.type: Easing.OutCubic; }
        }
    }

    Row {
        x: root.pad
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.wsCount

            delegate: Item {
                id: ws
                required property int index
                readonly property int workspaceId: index + 1
                readonly property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId)
                readonly property bool isActive: root.activeId === workspaceId
                readonly property var toplevel: workspace?.toplevels.values[0] ?? null
                readonly property string iconName: {
                    DesktopEntries.applications.values
                    const appId = toplevel?.wayland?.appId ?? ""
                    return appId ? (DesktopEntries.heuristicLookup(appId)?.icon ?? "") : ""
                }

                width: root.itemSize
                height: root.itemSize

                Rectangle {
                    anchors.centerIn: parent
                    width: root.indicatorSize
                    height: root.indicatorSize
                    radius: height / 2
                    color: Color.surface
                    opacity: ws.workspace && !ws.isActive ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: root.animMs; easing.type: Easing.OutCubic }
                    }
                }

                MaterialIcon {
                    anchors.centerIn: parent
                    visible: !ws.iconName
                    text: "fiber_manual_record"
                    color: ws.workspace && ws.isActive ? Color.onbg : Color.overlay
                    font.pixelSize: Size.xs - 5

                    Behavior on color {
                        ColorAnimation { duration: root.animMs; easing.type: Easing.OutCubic }
                    }
                }

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: Size.base
                    source: ws.iconName ? Quickshell.iconPath(ws.iconName, true) : ""
                    layer.enabled: true
                    layer.effect: MultiEffect { saturation: -0.8 }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.focusWorkspace(ws.workspaceId)
                    onWheel: wheel => {
                        if (wheel.angleDelta.y !== 0)
                            root.focusWorkspace(root.activeId + (wheel.angleDelta.y > 0 ? -1 : 1))
                    }
                }
            }
        }
    }
}