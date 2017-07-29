import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "Analysis GUI"
    width: 500; height: 700
    visible: true
    Item {
        id: res
        property double result: 0.0
    }
    Column{
        Row{
            Repeater {
                model: _plotvalues
                Column {
                    Text {text : name}
                    ComboBox {
                        textRole: "value"
                        model: _options
                        onCurrentIndexChanged: {chosen_value = currentText}
                    }
                }
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
                        onClicked: { split = checked;
                        Julia.my_function(jdisp)}
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
        JuliaDisplay {
            id: jdisp
            width: 500; height: 500
        }
    }

}
