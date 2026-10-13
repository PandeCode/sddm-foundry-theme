pragma Singleton

import QtQuick

QtObject {
    readonly property string font: "Titillium Web"

    readonly property color caption: "#ffe6c0"
    readonly property color text: "#ffffff"
    readonly property color red: "#ff8e8e"
    readonly property color orange: "#faa838"

    readonly property color frame: "#313031"
    readonly property color frameEdge: "#141414"
    readonly property color frameLight: "#4a484a"
    readonly property color inset: "#242324"
    readonly property color insetEdge: "#121112"
    readonly property color insetShadow: "#0b0b0b"

    readonly property color buttonText: "#1c1c1c"
    readonly property color buttonEdge: "#1d1d1d"
    readonly property color disabledText: "#7a7a7a"

    // [top, bottom] of the button face
    readonly property var faces: ({
        "grey": ["#a3a3a3", "#878787"],
        "green": ["#7cc680", "#56a55b"],
        "red": ["#f17c74", "#d6574f"]
    })
    readonly property var hoveredFaces: ({
        "grey": ["#fcc879", "#eda443"],
        "green": ["#97dc9b", "#68bd6d"],
        "red": ["#ff958d", "#e86b62"]
    })
    readonly property var pressedFaces: ({
        "grey": ["#e7962a", "#f2b05a"],
        "green": ["#4f9a54", "#6db872"],
        "red": ["#c8483f", "#e46a61"]
    })
    readonly property var glows: ({
        "grey": "#e1b16a",
        "green": "#87d88b",
        "red": "#fe5a5a"
    })
    readonly property var disabledFace: ["#6a6a6a", "#5a5a5a"]

    readonly property color field: "#bdbdbd"
    readonly property color fieldFocus: "#ececec"
    readonly property color fieldText: "#000000"
    readonly property color fieldPlaceholder: "#5c5c5c"
}
