import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components

Quick.Rectangle {
    id: root

    property var monthData

    property var date
    property bool disabled
    property bool isToday
    property bool hasNotes: false

    function load() {
        hasNotes = Boolean(
            db.getNotes(
                db.buildID(
                    root.date.getFullYear(),
                    root.date.getMonth() + 1,
                    root.date.getDate()
                )
            )
        )
    }

    color: "transparent"

    Quick.Rectangle {
        id: container

        anchors {
            centerIn: parent
        }

        width: label.height + units.gu(2)
        height: label.width + units.gu(2)

        radius: 5
        color: root.isToday ? "orange" : "transparent"

        Components.Label {
            id: label
            color: {
                if (root.disabled) {
                    return theme.palette.disabled.baseText
                }

                return root.hasNotes
                    ? Components.UbuntuColors.red
                    : theme.palette.normal.baseText
            }

            anchors {
                centerIn: parent
            }

            textSize: Components.Label.Medium
            //text: root.date.getDate().toString()
            text: `${root.monthData.Day}/${root.monthData.Date}`

            font.bold: !root.disabled
        }
    }

    onDateChanged: load()
}
