import QtQuick

Item {
    id: root

    property string text
    property string kind: "grey"

    signal clicked

    implicitWidth: 320
    implicitHeight: 50
    activeFocusOnTab: true

    Keys.onReturnPressed: if (enabled) clicked()
    Keys.onEnterPressed: if (enabled) clicked()
    Keys.onSpacePressed: if (enabled) clicked()

    Bevel {
        anchors.fill: parent
        kind: root.kind
        hot: area.containsMouse || root.activeFocus
        down: area.pressed
        active: root.enabled
    }

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: area.pressed ? 1 : -1
        text: root.text
        font.family: Style.font
        font.pixelSize: 18
        font.weight: Font.Bold
        color: root.enabled ? Style.buttonText : Style.disabledText
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
