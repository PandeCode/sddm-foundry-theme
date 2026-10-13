import QtQuick

// a frame with a caption and drag handle, children stack below it
Item {
    id: root

    property string title
    default property alias content: body.data

    implicitWidth: body.implicitWidth + 24
    implicitHeight: header.height + body.implicitHeight + 24

    Repeater {
        model: 8
        Rectangle {
            anchors.fill: parent
            anchors.margins: -(index + 1)
            anchors.topMargin: -index
            radius: 4 + index
            color: "transparent"
            border.color: Qt.rgba(0, 0, 0, 0.22 - index * 0.026)
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: Style.frame
        border.color: Style.frameEdge
    }

    Rectangle {
        x: 2
        y: 1
        width: parent.width - 4
        height: 1
        color: Style.frameLight
    }

    Row {
        id: header
        x: 12
        y: 6
        width: parent.width - 24
        height: 32
        spacing: 8

        Text {
            id: caption
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            font.family: Style.font
            font.pixelSize: 18
            font.weight: Font.Bold
            color: Style.caption
        }

        Stripes {
            anchors.verticalCenter: parent.verticalCenter
            width: header.width - caption.width - header.spacing
        }
    }

    Column {
        id: body
        x: 12
        y: header.y + header.height + 4
        spacing: 12
    }
}
