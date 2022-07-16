import QtQuick 2.7 as Quick

Quick.Item {
    id: month

    property int relativeIndex: index === 2 ? -1 : index
    property var date: updateDate()

    function updateDate() {
        const today = new Date()
        return new Date(
            today.getFullYear(),
            today.getMonth() + month.relativeIndex,
            1
        )
    }

    width: parent.width
    height: parent.height

    MonthGridHeader {
        id: gridHeader
    }

    MonthGrid {
        id: monthGrid

        date: month.date
    }

    Quick.Connections {
        target: main

        onVisibleIndexChanged: {
            // update (id: main, PathView) current relative index - update pageHeader date
            if (index === main.visibleIndex) {
                main.currentRelativeIndex = month.relativeIndex

                dateObject.set(
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
                dateObject.set(
                    new Date(month.date.getFullYear(), month.date.getMonth(), 1)
                )
            }
        }
    }

    onRelativeIndexChanged: date = updateDate()
}
