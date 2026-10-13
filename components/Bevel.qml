import QtQuick

// raised button face: dark outline, light top edge, glow when hot
Item {
    id: root

    property string kind: "grey"
    property bool hot: false
    property bool down: false
    property bool active: true

    readonly property var colors: !active ? Style.disabledFace
        : down ? Style.pressedFaces[kind]
        : hot ? Style.hoveredFaces[kind]
        : Style.faces[kind]

    Repeater {
        model: 4
        Rectangle {
            anchors.fill: parent
            anchors.margins: -(index + 1)
            radius: 4 + index
            color: "transparent"
            border.color: Style.glows[root.kind]
            opacity: (root.hot && root.active && !root.down) ? 0.45 - index * 0.1 : 0
        }
    }

    // dirt: the soft dark rim under every button
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 1
        anchors.bottomMargin: -2
        radius: 4
        color: "#640f0703"
        visible: !root.hot || !root.active
    }

    Rectangle {
        anchors.fill: parent
        radius: 3
        border.color: Style.buttonEdge
        gradient: Gradient {
            GradientStop { position: 0; color: root.colors[0] }
            GradientStop { position: 1; color: root.colors[1] }
        }
    }

    Rectangle {
        x: 2
        y: 1
        width: parent.width - 4
        height: 1
        color: root.down ? "#30000000" : "#70ffffff"
    }

    Rectangle {
        x: 2
        y: parent.height - 2
        width: parent.width - 4
        height: 1
        color: root.down ? "#30ffffff" : "#38000000"
    }
}
