import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import org.julialang 1.0

Rectangle {
    id: container
    width: 500; height: 400
    color: "white"
    Item {
        id: res
        property double result: 0.0
    }
    Row {
        Repeater {
            model: selectModel
            Column {
                //Text { text: name }
                Button {text : name; checked : false; checkable : true}
                Repeater {
                    model: attributes
                    CheckBox {
                        text: description;
                        checked : accepted;
                        onClicked: { accepted = checked}
                    }
                }
            }
        }
    }
}
