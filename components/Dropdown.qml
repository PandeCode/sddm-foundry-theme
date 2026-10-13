import QtQuick
import QtQuick.Controls.Basic

ComboBox {
    id: root

    implicitWidth: 200
    implicitHeight: 28
    font.family: Style.font
    font.pixelSize: 15
    font.weight: Font.DemiBold

    background: Bevel {
        hot: root.hovered || root.visualFocus || root.popup.visible
        down: root.pressed
        active: root.enabled
    }

    contentItem: Text {
        leftPadding: 8
        rightPadding: root.indicator.width + 8
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: root.displayText
        font: root.font
        color: Style.buttonText
    }

    indicator: Canvas {
        x: root.width - width - 8
        y: (root.height - height) / 2
        width: 10
        height: 6
        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(width / 2, height)
            ctx.closePath()
            ctx.fillStyle = Style.buttonText
            ctx.fill()
        }
    }

    delegate: ItemDelegate {
        id: item
        required property int index
        required property string name
        width: root.width - 4
        height: 28
        highlighted: root.highlightedIndex === index
        contentItem: Text {
            leftPadding: 4
            verticalAlignment: Text.AlignVCenter
            text: item.name
            font: root.font
            color: Style.buttonText
        }
        background: Rectangle {
            color: item.highlighted ? Style.hoveredFaces.grey[1] : "transparent"
        }
    }

    popup: Popup {
        y: root.height + 2
        width: root.width
        implicitHeight: contentItem.implicitHeight + 4
        padding: 2

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex
        }

        background: Rectangle {
            radius: 2
            color: Style.faces.grey[0]
            border.color: Style.buttonEdge
        }
    }
}
