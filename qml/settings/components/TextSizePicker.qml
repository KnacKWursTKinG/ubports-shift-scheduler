import QtQuick 2.12 as Quick
import QtQuick.Controls 2.12 as Controls

import Ubuntu.Components 1.3 as Components

import "../../js/textSize.js" as TextSize

Controls.ComboBox {
    id: textSizePicker

    property string _name
    property int _size

    function find(textSize) {
        textSize = textSize.toLowerCase()
        for (let idx = 0; idx < model.length; idx++) {
            const value = model[idx].toLowerCase()
            if (value === textSize) {
                return idx
            }
        }

        return find(TextSize.defaultSizeName(_name))
    }

    model: TextSize.model.slice(1)

    currentIndex: find(
        TextSize.model[_size] || TextSize.defaultSizeName(_name)
    )

    onCurrentTextChanged: _size = currentIndex + 1
}
