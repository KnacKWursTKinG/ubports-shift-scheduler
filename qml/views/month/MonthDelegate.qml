import QtQuick 2.12

Item {
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

    function loadData() {
        jsonMonthData = monthHandler.getMonth(month, date.getFullYear(), date.getMonth() + 1)
    }

    onRelativeIndexChanged: date = updateDate()

    onDateChanged: loadData()

    onJsonMonthDataChanged: {
        monthData = JSON.parse(jsonMonthData)
        monthHandler.watchToday(index, month, date.getFullYear(), date.getMonth() + 1)
    }

    width: parent.width
    height: parent.height

    GridHeader {
        id: gridHeader
    }

    MonthGrid {
        id: monthGrid

        month: month.date.getMonth() + 1
    }

    Connections {
        target: pathView 

        onVisibleIndexChanged: {
            // update (id: pathView, PathView) current relative index - update pageHeader date
            if (index === pathView.visibleIndex) {
                pathView.currentRelativeIndex = month.relativeIndex

                pageHeader.setDate(
                    new Date(month.date.getFullYear(), month.date.getMonth(), 1)
                )
            }
        }

        onCurrentRelativeIndexChanged: {
            // update the (month component) relative index
            if (pathView.currentRelativeIndex === month.relativeIndex)
                return

            const lastIndex = 2
            const firstIndex = 0

            // NOTE: pathView.visibleIndex is the PathView item which is visible right now
            if (index === lastIndex && pathView.visibleIndex === firstIndex)
                month.relativeIndex = pathView.currentRelativeIndex - 1
            else if (index === firstIndex && pathView.visibleIndex === lastIndex)
                month.relativeIndex = pathView.currentRelativeIndex + 1
            else if (index < pathView.visibleIndex)
                month.relativeIndex = pathView.currentRelativeIndex - 1
            else if (index > pathView.visibleIndex)
                month.relativeIndex = pathView.currentRelativeIndex + 1
            else {
                month.relativeIndex = pathView.currentRelativeIndex

                // update pageHeader date if current relative index property was changed
                pageHeader.setDate(
                    new Date(month.date.getFullYear(), month.date.getMonth(), 1)
                )
            }
        }
    }
}
