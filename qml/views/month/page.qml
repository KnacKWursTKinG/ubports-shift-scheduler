import QtQuick 2.12

import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

// TODO: ...
import "./dialogs" as Dialogs

Components.Page {
    header: Components.PageHeader {
        id: pageHeader

        property date currentDate

        function set(date) {
            currentDate = date
        }

        Quick.Component {
            id: datePicker

            Dialogs.PageHeaderDatePicker {
                id: datePickerPopup

                pickerDate: pageHeader.currentDate

                onClose: {
                    if (ok) main.goTo(pickerDate)
                }
            }
        }

        trailingActionBar.actions: [
            Components.Action {
                iconName: "settings"
                onTriggered: {
                    stack.clear()
                    stack.push(Qt.resolvedUrl("../settings/Page.qml"))
                }
            },
            Components.Action {
                iconName: "calendar-today"
                enabled: main.currentRelativeIndex !== 0
                onTriggered: main.currentRelativeIndex = 0
            }
        ]

        contents: Components.Button {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            width: units.gu(1.5) * dateLabel.text.length
            height: units.gu(4)
            strokeColor: theme.palette.normal.activity

            Components.Label {
                id: dateLabel

                anchors.centerIn: parent
                text: `${pageHeader.currentDate.getFullYear()} / ${pageHeader.currentDate.getMonth() + 1} - ${Qt.formatDate(pageHeader.currentDate, "MMMM")}`
                textSize: Components.Label.Large
            }

            onClicked: {
                PopupUtils.open(datePicker)
            }
        }

        Quick.Component.onCompleted: {
            set(new Date())
        }
    }

    Quick.PathView {
        id: main

        // current index of 2 is the real index 0
        property int visibleIndex: 0

        // Update this property to move to a specific month (0 == today, -1 == prev. month, ...)
        property int currentRelativeIndex: 0

        function goTo(newDate) {
            const today = new Date()
            const year = newDate.getFullYear()
            const month = newDate.getMonth()
            currentRelativeIndex = ((year - today.getFullYear()) * 12) + (month - today.getMonth())
        }

        currentIndex: 2
        snapMode: Quick.PathView.SnapOneItem
        antialiasing: true

        anchors {
            fill: parent
            topMargin: pageHeader.height
        }

        model: 3

        path: Quick.Path {
            startX: -(main.width / 2)
            startY: main.height / 2

            Quick.PathLine {
                x: (main.width) * 3 - main.width / 2
                relativeY: 0
            }
        }

        delegate: Quick.Component {
            Month {}
        }

        onCurrentIndexChanged: {
            let realIndex = currentIndex + 1
            if (realIndex > 2) realIndex = 0
            visibleIndex = realIndex
        }
    }
}
