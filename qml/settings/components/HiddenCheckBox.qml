import QtQuick 2.7 as Quick

import Ubuntu.Components 1.3 as Components

Quick.Item {
    id: root

    property var item

    width: layout.width
    height: layout.height

    Quick.MouseArea {
        anchors.fill: parent
        onClicked: checkbox.checked = !checkbox.checked
    }

    Quick.Column {
        id: layout

        anchors.centerIn: parent
        width: label.width
        spacing: units.gu(0.5)

        Components.Label {
            id: label

            text: tr.get("Hidden")
            textSize: Components.Label.Small
        }

        Components.CheckBox {
            id: checkbox

            anchors.horizontalCenter: parent.horizontalCenter

            onCheckedChanged: item.hidden = checked
        }
    }

    onItemChanged: (item) && (checkbox.checked = item.hidden)
}
