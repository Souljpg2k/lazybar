import qs.styles
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

Scope {
    id: root
    readonly property int corner: 26
    
    readonly property var corners: [
        { pos: "TopLeft", gap: false },
        { pos: "TopLeft", gap: true },
        { pos: "TopRight", gap: false },
        { pos: "TopRight", gap: true },
        { pos: "BottomLeft", gap: false },
        { pos: "BottomRight", gap: false }
    ]

    Variants {
        model: Quickshell.screens

        Instantiator {
            id: inst
            required property var modelData
            model: root.corners

            delegate: PanelWindow {
                id: w
                required property var modelData
                readonly property bool isGap: modelData.gap
                readonly property bool left: modelData.pos.endsWith("Left")
                readonly property bool bottom: modelData.pos.startsWith("Bottom")
                readonly property color fill: isGap ? "black" : Color.bg

                screen: inst.modelData
                anchors {
                    top: !bottom
                    bottom: bottom
                    left: left
                    right: !left
                }
                implicitWidth: root.corner
                implicitHeight: root.corner
                exclusionMode: isGap ? ExclusionMode.Ignore : ExclusionMode.Auto
                WlrLayershell.layer: WlrLayer.Overlay
                color: "transparent"
                mask: Region {}

                Shape {
                    anchors.fill: parent
                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        fillColor: w.fill
                        strokeColor: "transparent"
                        startX: w.left ? 0 : root.corner
                        startY: w.bottom ? root.corner : 0

                        PathLine {
                            x: w.left ? root.corner : 0
                            y: w.bottom ? root.corner : 0
                        }

                        PathQuad {
                            x: w.left ? 0 : root.corner
                            y: w.bottom ? 0 : root.corner
                            controlX: w.left ? 0 : root.corner
                            controlY: w.bottom ? root.corner : 0
                        }
                    }
                }
            }
        }
    }
}