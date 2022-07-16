import QtQuick 2.7 as Quick

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.ListItems 1.3 as ListItems

import "../components"

import "../../js/textSize.js" as TextSize

Popups.Dialog {
    id: root

    property var item

    Components.Label {
        width: parent.width
        text: item.name
        textSize: TextSize.get(item)
        color: item.shiftColor || theme.palette.normal.baseText
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    ListItems.Divider {}

    Components.Label {
        width: parent.width
        text: tr.get("TextSize")
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    TextSizePicker {
        item: root.item
    }

    ListItems.Divider {}

    Components.Label {
        width: parent.width
        text: tr.get("Color")
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    ColorPicker {
        item: root.item
    }

    ListItems.Divider {}

    Components.Button {
        text: tr.get("Close")
        onTriggered: {
            PopupUtils.close(root)
        }
    }
}
