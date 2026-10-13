import QtQuick

FocusScope {
    id: root

    property alias text: input.text
    property alias echoMode: input.echoMode
    property string placeholder

    signal accepted

    implicitWidth: 200
    implicitHeight: 28

    function forceFocus() {
        input.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: parent
        radius: 2
        color: input.activeFocus ? Style.fieldFocus : Style.field
        border.color: input.activeFocus ? Style.orange : Style.buttonEdge
    }

    Rectangle {
        x: 1
        y: 1
        width: parent.width - 2
        height: 2
        color: "#30000000"
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: TextInput.AlignVCenter
        focus: true
        clip: true
        font.family: Style.font
        font.pixelSize: 15
        color: Style.fieldText
        selectionColor: Style.orange
        selectedTextColor: Style.fieldText
        passwordCharacter: "\u2022"
        onAccepted: root.accepted()
    }

    Text {
        anchors.fill: input
        verticalAlignment: Text.AlignVCenter
        visible: input.text === "" && !input.activeFocus
        text: root.placeholder
        font: input.font
        color: Style.fieldPlaceholder
    }
}
