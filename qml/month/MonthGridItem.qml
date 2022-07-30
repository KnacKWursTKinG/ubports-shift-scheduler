import QtQuick 2.12 as Quick
import QtQuick.Layouts 1.3 as Layouts

import Ubuntu.Components.Popups 1.3 as Popups

import "./dialogs" as Dialogs

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
                monthHandler.updateShift(root.dayData.date, shift)
                monthHandler.updateNotes(root.dayData.date, notes)
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
