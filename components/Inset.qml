import QtQuick

// the sunken dark panel content sits in
Item {
    id: root

    default property alias content: body.data

    implicitWidth: body.implicitWidth + 24
    implicitHeight: body.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: 2
        color: Style.inset
        border.color: Style.insetEdge
    }

    Repeater {
        model: 3
        Rectangle {
            x: 1
            y: 1 + index
            width: root.width - 2
            height: 1
            color: Style.insetShadow
            opacity: 0.8 - index * 0.25
        }
    }

    Rectangle {
        x: 1
        y: root.height
        width: root.width - 2
        height: 1
        color: "#3c3b3c"
    }

    Column {
        id: body
        x: 12
        y: 12
        spacing: 8
    }
}
