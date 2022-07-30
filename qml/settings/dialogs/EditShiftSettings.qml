import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Components.ListItems 1.3 as ListItems

import "../components"

import "../../js/textSize.js" as TextSize

Popups.Dialog {
    id: root

    property string _name
    property alias _color: colorPicker._color
    property alias _size: textSizePicker._size

    signal close(bool ok)

    Components.Label {
        width: parent.width
        text: root._name
        textSize: TextSize.get(root._name, root._size)
        color: root._color || theme.palette.normal.baseText
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    ListItems.Divider {}

    Components.Label {
        width: parent.width
        text: tr.get("TextSize")
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    TextSizePicker {
        id: textSizePicker
        _name: root._name
    }

    ListItems.Divider {}

    Components.Label {
        width: parent.width
        text: tr.get("Color")
        horizontalAlignment: Quick.Text.AlignHCenter
    }

    ColorPicker {
        id: colorPicker
    }

    ListItems.Divider {}

    Components.Button {
        text: tr.get("Update")
        color: theme.palette.normal.positive
        onTriggered: {
            close(true)
            PopupUtils.close(root)
        }
    }

    Components.Button {
        text: tr.get("Cancel")
        onTriggered: {
            close(false)
            PopupUtils.close(root)
        }
    }
}
