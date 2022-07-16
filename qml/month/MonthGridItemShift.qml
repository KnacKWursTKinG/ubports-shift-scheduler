import QtQuick 2.7 as Quick

import Ubuntu.Components 1.3 as Components

import "../js/helper.js" as Helper
import "../js/textSize.js" as TextSize

Quick.Rectangle {
    id: root

    property alias isVisible: container.visible

    property bool landscapeMode
    property var date
    property bool disabled

    property var item

    function load() {
        item = settings.shifts.config.get(
            Helper.getShift(
                date.getFullYear(),
                date.getMonth() + 1,
                date.getDate()
            )
        )
    }

    color: "transparent"

    Quick.Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: {
            const maxWidth = parent.width - border.width * 2
            let newWidth = (label.text.length + 3) * label.font.pointSize

            if (newWidth > maxWidth) {
                return maxWidth
            }

            return newWidth
        }
        height: label.font.pointSize * 3

        radius: 5
        visible: !root.disabled
            && item.name
            && !item.hidden

        color: "transparent"

        border {
            color: settings.shiftBorder
                ? item.shiftColor || theme.palette.normal.base
                : "transparent"
        }

        Components.Label {
            id: label

            width: parent.width
            height: parent.height
            horizontalAlignment: Quick.Text.AlignHCenter
            verticalAlignment: Quick.Text.AlignVCenter

            color: item.shiftColor
                || theme.palette.normal.baseText

            text: item.name
            textSize: TextSize.get(item)

            font.italic: true

            elide: Quick.Text.ElideRight
        }
    }

    onDateChanged: load()
}
