import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "Save Your Plot"
    width: 620
    height: 420
    visible: true

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        selectMultiple: false
        selectExisting: false
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            choose.value = fileDialog.fileUrl
            Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
        Component.onCompleted: visible = true
    }
}




filename = QtGui.QFileDialog.getSaveFileName(self, "Save file", "", ".conf")
