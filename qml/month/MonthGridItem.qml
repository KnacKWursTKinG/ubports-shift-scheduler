import QtQuick 2.7 as Quick
import QtQuick.Layouts 1.3 as Layouts

import Ubuntu.Components.Popups 1.3 as Popups

import "./dialogs" as Dialogs

Quick.Rectangle {
    id: root

    property var date
    property string notes: ""

    property var isToday: {
        const today = new Date()
        return (today.getFullYear() === date.getFullYear()
                && today.getMonth() === date.getMonth()
                && today.getDate() === date.getDate())
    }

    property var disabled: false

    Layouts.Layout.fillHeight: true
    Layouts.Layout.fillWidth: true

    radius: 0
    color: "transparent"
    clip: true

    Quick.Component {
        id: dayDialog

        Dialogs.Day {
            year: root.date.getFullYear()
            month: root.date.getMonth() + 1
            day: root.date.getDate()

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

                monthGridItemDate.load()
                monthGridItemShift.load()
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

        date: root.date
        disabled: root.disabled
        isToday: root.isToday

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

        date: root.date
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
