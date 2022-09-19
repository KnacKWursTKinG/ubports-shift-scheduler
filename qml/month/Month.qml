import QtQuick 2.12 as Quick

Quick.Item {
    id: month

    property int relativeIndex: index === 2 ? -1 : index
    property var date: updateDate()
    property alias monthData: monthGrid.monthData
    property string jsonMonthData

    function updateDate() {
        const today = new Date()
        return new Date(
            today.getFullYear(),
            today.getMonth() + month.relativeIndex,
            1
        )
    }

    onRelativeIndexChanged: date = updateDate()

    onDateChanged: {
        jsonMonthData = monthHandler.getMonth(month, date.getFullYear(), date.getMonth() + 1)
    }

    onJsonMonthDataChanged: {
        monthData = JSON.parse(jsonMonthData)
        // TODO: start event listener (monthHandler.WatchToday(month, date.getFullYear(), date.getMonth + 1))
    }

    width: parent.width
    height: parent.height

    MonthGridHeader {
        id: gridHeader
    }

    MonthGrid {
        id: monthGrid

        month: month.date.getMonth() + 1
    }

    Quick.Connections {
        target: main

        onVisibleIndexChanged: {
            // update (id: main, PathView) current relative index - update pageHeader date
            if (index === main.visibleIndex) {
                main.currentRelativeIndex = month.relativeIndex

                pageHeader.set(
                    new Date(month.date.getFullYear(), month.date.getMonth(), 1)
                )
            }
        }

        onCurrentRelativeIndexChanged: {
            // update the (month component) relative index
            if (main.currentRelativeIndex === month.relativeIndex)
                return

            const lastIndex = 2
            const firstIndex = 0

            // NOTE: main.visibleIndex is the PathView item which is visible right now
            if (index === lastIndex && main.visibleIndex === firstIndex)
                month.relativeIndex = main.currentRelativeIndex - 1
            else if (index === firstIndex && main.visibleIndex === lastIndex)
                month.relativeIndex = main.currentRelativeIndex + 1
            else if (index < main.visibleIndex)
                month.relativeIndex = main.currentRelativeIndex - 1
            else if (index > main.visibleIndex)
                month.relativeIndex = main.currentRelativeIndex + 1
            else {
                month.relativeIndex = main.currentRelativeIndex

                // update pageHeader date if current relative index property was changed
                pageHeader.set(
                    new Date(month.date.getFullYear(), month.date.getMonth(), 1)
                )
            }
        }
    }
}
