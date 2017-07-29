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
    Column{
        Row{
            ComboBox {
                currentIndex: 0
                model: xvalues
                onCurrentIndexChanged: {_plotvalues.x = currentIndex}
            }
        }
        Row {

            Repeater {
                model: _selectlist
                Column {
                    //Text { text: name }
                    Button {
                        text : name;
                        checked : false;
                        checkable : true;
                        onClicked: { split = checked}
                    }
                    Repeater {
                        model: _values
                        CheckBox {
                            text: name;
                            checked : accepted;
                            onClicked: { accepted = checked}
                        }
                    }
                }
            }
        }
    }
}
