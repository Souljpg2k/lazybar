import qs.services
import qs.styles
import QtQuick
import QtQuick.Layouts

Item {
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    TextMetrics {
        id: metrics
        font: cpuText.font
        text: "100"
    }

    Row {
        id: content
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        RowLayout {
            MaterialIcon {
                text: "memory"
            }

            BodyText {
                id: cpuText
                text: SysService.cpu
                Layout.preferredWidth: metrics.advanceWidth
            }
        }

        RowLayout {
            MaterialIcon {
                text: "earthquake"
            }

            BodyText {
                text: SysService.mem
                Layout.preferredWidth: metrics.advanceWidth
            }
        }
    }
}
