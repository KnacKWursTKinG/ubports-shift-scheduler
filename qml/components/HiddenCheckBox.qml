import QtQuick 2.12

import Ubuntu.Components 1.3

Item {
    property var item

    width: layout.width
    height: layout.height

    MouseArea {
        anchors.fill: parent
        onClicked: checkbox.checked = !checkbox.checked
    }

    Column {
        id: layout

        anchors.centerIn: parent
        width: label.width
        spacing: units.gu(0.5)

        Label {
            id: label

            text: tr.get("Hidden")
            textSize: Components.Label.Small
        }

        CheckBox {
            id: checkbox
            anchors.horizontalCenter: parent.horizontalCenter
            onCheckedChanged: item.hidden = checked
        }
    }

    onItemChanged: (item) && (checkbox.checked = item.hidden)
}
