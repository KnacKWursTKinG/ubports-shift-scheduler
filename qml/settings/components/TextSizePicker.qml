import QtQuick 2.7 as Quick
import QtQuick.Controls 2.5 as Controls

import Ubuntu.Components 1.3 as Components

import "../../js/textSize.js" as TextSize

Controls.ComboBox {
    id: textSizePicker

    property var item

    function find(textSize) {
        textSize = textSize.toLowerCase()
        for (let idx = 0; idx < model.length; idx++) {
            const value = model[idx].toLowerCase()
            if (value === textSize) {
                return idx
            }
        }

        return find(TextSize.defaultSizeName(item.name))
    }

    model: TextSize.model.slice(1)

    currentIndex: find(
        TextSize.model[item.textSize] || TextSize.defaultSizeName(item.name)
    )

    onCurrentTextChanged: item.textSize = currentIndex + 1
}
