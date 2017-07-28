import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "My Application"
    width: 620
    height: 420
    visible: true

FileDialog {
    id: fileDialog
    title: "Please choose a file"
    folder: shortcuts.home
    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
        Qt.quit()
    }
    onRejected: {
        console.log("Canceled")
        Qt.quit()
    }
    Component.onCompleted: visible = true
}
}
