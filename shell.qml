import qs.styles
import qs.modules
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    id: root
    property bool mediaHoverBar: false

    PersistentProperties {
        id: kino
        reloadableId: "kino"

        property bool barOpen: false
        property bool clockOpen: false
        property bool mediaOpen: false
    }


    GlobalShortcut {
        appid: "kino"
        name: "bar"
        onPressed: kino.barOpen = !kino.barOpen
    }

    GlobalShortcut {
        appid: "kino"
        name: "clock"
        onPressed: kino.clockOpen = !kino.clockOpen
    }

    GlobalShortcut {
        appid: "kino"
        name: "media"
        onPressed: kino.mediaOpen = !kino.mediaOpen
    }

    GlobalShortcut {
        appid: "kino"
        name: "toggleDark"
        onPressed: Color.toggle()
    }

    Bar {}
    Clock {}
    Notifications {}
}