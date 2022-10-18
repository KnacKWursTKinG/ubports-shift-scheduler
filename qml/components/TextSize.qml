pragma Singleton
import QtQuick 2.12

import Ubuntu.Components 1.3

QtObject {
    property var _model: [
        null,
        "XXSmall",
        "XSmall",
        "Small",
        "Medium",
        "Large",
        "XLarge"
    ]

    property var sizes: [
        null,
        Label.XxSmall,
        Label.XSmall,
        Label.Small,
        Label.Medium,
        Label.Large,
        Label.XLarge
    ]

    /**
     * @returns {string} text
     * @returns {string}
     */
    function getDefaultSizeName(text) {
        return text.length > 5 ? _model[3] : text.length < 3 ? _model[5] : _model[4]
    }

    /**
     * @param {string} text
     */
    function getDefaultSize(text) {
        return sizes[
            _model.indexOf(getDefaultSizeName(text))
        ]
    }

    /**
     * @param {string} text - text to handle
     * @param {number} sizeIndex - property `sizes` index
     */
    function getSize(text, sizeIndex = null) {
        return (sizeIndex || 0) > 0 ? sizes[sizeIndex] : getDefaultSize(text)
    }
}
