import QtQuick 2.12

import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../../dialogs"

Page {
    id: monthPage

    header: PageHeader {
        id: pageHeader

        property date currentDate

        function setDate(date) {
            currentDate = date
        }

        Component {
            id: datePicker

            DatePickerDialog {
                id: datePickerPopup

                pickerDate: pageHeader.currentDate

                onClose: {
                    if (ok) pathView.goTo(pickerDate)
                }
            }
        }

        trailingActionBar.actions: [
            Action {
                iconName: "settings"
                onTriggered: {
                    //stack.clear()
                    stack.push(Qt.resolvedUrl("../settings/page.qml"))
                }
            },
            Action {
                iconName: "calendar-today"
                enabled: pathView.currentRelativeIndex !== 0
                onTriggered: pathView.currentRelativeIndex = 0
            }
        ]

        contents: Button {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            width: units.gu(1.5) * dateLabel.text.length
            height: units.gu(4)
            strokeColor: theme.palette.normal.activity

            Label {
                id: dateLabel

                anchors.centerIn: parent
                text: `${pageHeader.currentDate.getFullYear()} / ${pageHeader.currentDate.getMonth() + 1} - ${Qt.formatDate(pageHeader.currentDate, "MMMM")}`
                textSize: Label.Large
            }

            onClicked: {
                PopupUtils.open(datePicker)
            }
        }

        Component.onCompleted: setDate(new Date())
    }

    PathView {
        id: pathView 

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

        function reload() {
            for (let i = 3; i > 0; i--) {
                pathView.data[i].loadData()
            }
        }

        currentIndex: 2
        snapMode: PathView.SnapOneItem
        antialiasing: true

        anchors {
            fill: parent
            topMargin: pageHeader.height
        }

        model: 3

        path: Path {
            startX: -(pathView.width / 2)
            startY: pathView.height / 2

            PathLine {
                x: (pathView.width) * 3 - pathView.width / 2
                relativeY: 0
            }
        }

        delegate: MonthDelegate {}

        onCurrentIndexChanged: {
            let realIndex = currentIndex + 1
            if (realIndex > 2) realIndex = 0
            visibleIndex = realIndex
        }
    }

    Connections {
        target: stack
        onCurrentPageChanged: {
            // NOTE: this will reload data when leave the settings page, but on app start loadData is called twice
            if (currentPage === monthPage) {
                pathView.reload()
            }
        }
    }
}
