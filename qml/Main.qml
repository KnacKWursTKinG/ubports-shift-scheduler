import QtQuick 2.12

import Ubuntu.Components 1.3

MainView {
    width: units.gu(45)
    height: units.gu(75)

    applicationName: "shift-scheduler.knackwurstking"

    PageStack {
        id: stack

        Component.onCompleted: {
            theme.name = ctxObject.theme
            stack.push(Qt.resolvedUrl("./views/month/page.qml"))
        }
    }
}
