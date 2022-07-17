import QtQuick 2.12 as Quick

import Ubuntu.Components 1.3 as Components

Components.MainView {
    width: units.gu(45)
    height: units.gu(75)

    applicationName: "shift-scheduler.knackwurstking"

    Components.PageStack {
        id: stack

        Quick.Component.onCompleted: {
            theme.name = settings.theme
            console.log("theme.name:", theme.name)
            stack.push(Qt.resolvedUrl("./month/Page.qml"))
        }
    }
}
