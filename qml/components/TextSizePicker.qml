import QtQuick 2.12
import QtQuick.Controls 2.12

import Ubuntu.Components 1.3

Controls.ComboBox {
    id: textSizePicker

    property string text
    property int size

    function find(textSize) {
        textSize = textSize.toLowerCase()
        for (let idx = 0; idx < model.length; idx++) {
            const value = model[idx].toLowerCase()
            if (value === textSize) {
                return idx
            }
        }

        return find(TextSize.getDefaultSizeName(textSizePicker.text))
    }

    model: TextSize._model.slice(1)

    currentIndex: find(
        TextSize.model[textSizePicker.size] || TextSize.getDefaultSizeName(textSizePicker.text)
    )

    onCurrentTextChanged: textSizePicker.size = currentIndex + 1
}
