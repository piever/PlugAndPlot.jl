import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

Rectangle {
    id: container
    width: 500; height: 400
    color: "white"
    Row {
        Repeater {
            model: selectModel
            Column {
                Text { text: name }
                Repeater {
                    model: attributes
                    CheckBox { text: description }
                }
            }
        }
    }
}
