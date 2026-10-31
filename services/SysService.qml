pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property int cpu: 0
    property int mem: 0
    property var prev: null

    Process {
        id: cpuProc
        command: ["head", "-n1", "/proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const f = data.trim().split(/\s+/).slice(1, 9).map(Number)
                const idle = f[3] + f[4]
                const total = f.reduce((a, b) => a + b, 0)
                const prev = root.prev
                const dTotal = total - (prev?.total ?? total)
                
                if (dTotal > 0) {
                    root.cpu = Math.round(100 * (1 - (idle - (prev?.idle ?? idle)) / dTotal))
                }
                root.prev = { idle, total }
            }
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep '^Mem:'"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const parts = data.trim().split(/\s+/)
                const total = Number(parts[1])
                const available = Number(parts[6])
                
                if (total > 0 && available >= 0)
                    root.mem = Math.round(100 * (1 - available / total))
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 2000
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }
}