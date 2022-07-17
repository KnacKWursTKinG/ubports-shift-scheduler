import QtQuick.Controls 2.12 as Controls

import Ubuntu.Components 1.3 as Components

import "../../js/color.js" as Color

Controls.ComboBox {
    id: colorPicker

    property var item

    // return default (index 0) if not found
    function find(shiftColor) {
        for (let idx = 0; idx < model.length; idx++) {
            const modelData = model[idx]
            if (modelData === shiftColor) return idx
        }

        return 0 
    }

    model: Color.colors
    delegate: Controls.ItemDelegate {
        width: parent.width
        height: units.gu(4)

        highlighted: index === colorPicker.currentIndex

        Components.Label {
            anchors.centerIn: parent
            text: modelData
            color: modelData === "default" ? theme.palette.normal.baseText : modelData
        }
    }

    // set initial current index
    currentIndex: find(item.shiftColor)

    // replace default with empty string and set selection to item
    onCurrentTextChanged: item.shiftColor = (currentText === "default")
        ? ""
        : currentText
}
