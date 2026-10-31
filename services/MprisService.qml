pragma Singleton

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root
    readonly property var players: Mpris.players.values
    property MprisPlayer lastPlayed: null
    readonly property var playingPlayer: lastPlayed?.isPlaying ? lastPlayed : (players.find(p => p.isPlaying) ?? null)
    readonly property var firstPlayer: players.length > 0 ? players[0] : null
    readonly property var player: playingPlayer ?? lastPlayed ?? firstPlayer

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: {
                if (modelData.isPlaying)
                    root.lastPlayed = modelData
            }

            function onPlaybackStateChanged() {
                if (modelData.isPlaying)
                    root.lastPlayed = modelData
            }
        }
    }

    function togglePlaying() {
        if (player?.canTogglePlaying)
            player.togglePlaying()
    }

    function fmt(s) {
        s = Math.floor(s || 0)
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0")
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.player?.isPlaying ?? false
        onTriggered: root.player?.positionChanged()
    }
}