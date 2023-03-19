import QtQuick 2.12
import QtQuick.Layouts 1.12

import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

import "../../dialogs"

Page {
    id: monthPage

    header: PageHeader {
        id: header 

        property date currentDate: new Date()

        Component {
            id: datePicker

            DatePickerDialog {
                id: datePickerPopup

                pickerDate: header.currentDate

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
                text: `${header.currentDate.getFullYear()} / ${header.currentDate.getMonth() + 1} - ${Qt.formatDate(header.currentDate, "MMMM")}`
                textSize: Label.Large
            }

            onClicked: {
                PopupUtils.open(datePicker)
            }
        }
    }

    PathView {
        id: pathView 

        // Update this property to move to a specific month (0 == today, -1 == prev. month, ...)
        property int currentRelativeIndex: 0

        // current index of 2 is the real index 0
        property int visibleIndex: 0

        function goTo(newDate) {
            const today = new Date()
            const year = newDate.getFullYear()
            const month = newDate.getMonth()
            currentRelativeIndex = ((year - today.getFullYear()) * 12) + (month - today.getMonth())
        }

        currentIndex: 2
        onCurrentIndexChanged: {
            let realIndex = currentIndex + 1
            if (realIndex > 2) realIndex = 0
            visibleIndex = realIndex
        }

        snapMode: PathView.SnapOneItem
        antialiasing: true

        anchors {
            fill: parent
            topMargin: header.height
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

        delegate: Item {
            id: monthDelegate 

            width: parent.width
            height: parent.height

            property var date: new Date()
            onDateChanged: load()

            property int relativeIndex: index === 2 ? -1 : index
            onRelativeIndexChanged: {
                var t = new Date()
                date = new Date(t.getFullYear(), t.getMonth()+relativeIndex, 1)
            }

            property string jMData
            onJMDataChanged: {
                if (jMData && date) {
                    monthGrid.mData = JSON.parse(jMData)
                    mh.watchToday(index, monthDelegate, date.getFullYear(), date.getMonth() + 1)
                }
            }

            function load() {
                jMData = mh.getMonth(monthDelegate, date.getFullYear(), date.getMonth()+1)
            }

            GridHeader {
                id: gridHeader
            }

            GridLayout {
                id: monthGrid

                anchors {
                    top: gridHeader.bottom
                    topMargin: rowSpacing
                    right: parent.right
                    rightMargin: columnSpacing
                    bottom: parent.bottom
                    bottomMargin: rowSpacing
                    left: parent.left
                    leftMargin: columnSpacing
                }

                columns: 7
                rows: 6
                columnSpacing: 0
                rowSpacing: 0
                clip: true

                property var mData: []

                Repeater {
                    model: monthGrid.mData.length // 42

                    Rectangle {
                        id: gridItem

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        radius: 0
                        color: "transparent"
                        clip: true

                        property var dData: monthGrid.mData[index]
                        property bool disabled: dData.Date.Month !== monthDelegate.date.getMonth()+1
                        property string jDData
                        onJDDataChanged: {
                            if (jDData) {
                                dData = JSON.parse(jDData)
                            }
                        }

                        border {
                            color: ctxo.gridBorder
                                ? theme.palette.normal.foreground
                                : "transparent"
                        }

                        Component {
                            id: dayDialog

                            DayDialog {
                                date: gridItem.dData.Date
                                shift: gridItem.dData.Shift.Name
                                notes: gridItem.dData.Notes

                                title: Qt.formatDate(
                                    new Date(date.Year, date.Month-1, date.Day),
                                    "yyyy / MMMM / dd"
                                )

                                onClose: {
                                    const year = gridItem.dData.Date.Year
                                    const month = gridItem.dData.Date.Month
                                    const day = gridItem.dData.Date.Day

                                    mh.updateShift(year, month, day, shift.trim())
                                    mh.updateNotes(year, month, day, notes.trim())
                                    mh.get(gridItem, year, month, day)
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: !gridItem.disabled
                            onClicked: {
                                PopupUtils.open(dayDialog)
                            }
                        }

                        DateItem {
                            id: gridItemDate

                            dData: gridItem.dData
                            disabled: gridItem.disabled

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

                        ShiftItem {
                            id: monthGridItemShift

                            dData: gridItem.dData
                            disabled: gridItem.disabled

                            anchors {
                                right: parent.right
                                bottom: parent.bottom
                            }

                            width: parent.width > parent.height
                                ? parent.width - gridItemDate.width
                                : parent.width
                            height: parent.width > parent.height
                                ? parent.height
                                : parent.height - gridItemDate.height

                            landscapeMode: parent.width > parent.height
                        }

                        Connections {
                            target: monthGrid

                            onMDataChanged: {
                                gridItem.dData = monthGrid.mData[index]
                                gridItem.disabled = gridItem.dData.Date.Month !== monthDelegate.date.getMonth()+1
                            }
                        }
                    }
                }
            }

            Connections {
                target: pathView 

                onVisibleIndexChanged: {
                    if (index === pathView.visibleIndex) {
                        pathView.currentRelativeIndex = monthDelegate.relativeIndex
                        header.currentDate = new Date(date.getFullYear(), date.getMonth(), 1)
                    }
                }

                onCurrentRelativeIndexChanged: {
                    if (pathView.currentRelativeIndex === monthDelegate.relativeIndex)
                        return

                    const lastIndex = 2
                    const firstIndex = 0

                    if (index === lastIndex && pathView.visibleIndex === firstIndex)
                        monthDelegate.relativeIndex = pathView.currentRelativeIndex - 1
                    else if (index === firstIndex && pathView.visibleIndex === lastIndex)
                        monthDelegate.relativeIndex = pathView.currentRelativeIndex + 1
                    else if (index < pathView.visibleIndex)
                        monthDelegate.relativeIndex = pathView.currentRelativeIndex - 1
                    else if (index > pathView.visibleIndex)
                        monthDelegate.relativeIndex = pathView.currentRelativeIndex + 1
                    else {
                        monthDelegate.relativeIndex = pathView.currentRelativeIndex
                        header.currentDate = new Date(date.getFullYear(), date.getMonth(), 1)
                    }
                }
            }
        }
    }

    Connections {
        target: stack
        onCurrentPageChanged: {
            if (currentPage === monthPage) {
                for (let i = 3; i > 0; i--) {
                    // reload data from month delegate items
                    pathView.data[i].load()
                }
            }
        }
    }
}
