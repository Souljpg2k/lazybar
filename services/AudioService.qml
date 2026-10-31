pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink?.audio
    readonly property bool muted: audio?.muted ?? false
    readonly property int volumePercent: Math.round(clamp(audio?.volume ?? 0) * 100)

    function clamp(v) {
        return Math.max(0, Math.min(1, v))
    }

    function changeVolume(delta) {
        if (audio)
            audio.volume = clamp(audio.volume + delta)
    }

    function toggleMute() {
        if (audio)
            audio.muted = !audio.muted
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}