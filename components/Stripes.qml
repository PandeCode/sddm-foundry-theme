import QtQuick

// the ridged drag handle that fills the rest of a title bar
Item {
    implicitHeight: 24

    Repeater {
        model: 6
        Item {
            y: 1 + index * 4
            width: parent.width
            height: 2

            Rectangle {
                width: parent.width
                height: 1
                color: "#1b1a1b"
            }
            Rectangle {
                y: 1
                width: parent.width
                height: 1
                color: "#474547"
            }
        }
    }
}
