import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.3 as Layouts

import Ubuntu.Components.Popups 1.3 as Popups

import "./dialogs" as Dialogs

// TODO: db is not defined
Quick.Rectangle {
    id: root

    property var dayData
    property var disabled: false

    Layouts.Layout.fillHeight: true
    Layouts.Layout.fillWidth: true

    radius: 0
    color: "transparent"
    clip: true

    Quick.Component {
        id: dayDialog

        Dialogs.Day {
            dayData: root.dayData

            title: Qt.formatDate(root.date, "yyyy / MMMM / dd")

            onClose: (shift, notes) => {
                const id = db.buildID(year, month, day)

                // handle shift
                let err = null
                if (shift !== settings.shifts.getShift(year, month, day))
                    err = db.setShift(id, shift)
                else
                    err = db.removeShift(id)

                if (err)
                    console.error(`error: shifts (${shift}): ${err.error()}`)

                // handle notes
                err = null
                if (!notes)
                    err = db.removeNotes(id)
                else
                    err = db.setNotes(id, notes)

                if (err)
                    console.error(`error: notes: ${err.error()}`)

                monthHandler.get(root, root.dayData.date)
            }
        }
    }

    Quick.MouseArea {
        anchors.fill: parent
        enabled: !root.disabled
        onClicked: {
            PopupUtils.open(dayDialog)
        }
    }

    MonthGridItemDate {
        id: monthGridItemDate

        dayData: root.dayData
        disabled: root.disabled

        anchors {
            top:  parent.top
            left: parent.left
        }

        width: parent.width > parent.height
            ? units.gu(6)
            : parent.width
        height: parent.width > parent.height
            ? parent.height
            : parent.height / 2
    }

    MonthGridItemShift {
        id: monthGridItemShift

        dayData: root.dayData
        disabled: root.disabled

        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        width: parent.width > parent.height
            ? parent.width - monthGridItemDate.width
            : parent.width
        height: parent.width > parent.height
            ? parent.height
            : parent.height - monthGridItemDate.height

        landscapeMode: parent.width > parent.height
    }
}
