import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import org.julialang 1.0

ApplicationWindow {
  title: "Plug And Plot"
  width: 620
  height: 420
  visible: true

  FileDialog {
    id: fileDialog
    title: "Please choose a file"
    folder: shortcuts.home
    selectMultiple: false
    nameFilters: [ "Csv files (*.csv)", "All files (*)" ]
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
