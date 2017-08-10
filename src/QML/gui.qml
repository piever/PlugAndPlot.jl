import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "Analysis GUI"
    width: 1000; height: 800
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
                        onCurrentIndexChanged: {
                            if (currentText != "")
                                chosen_value = currentText
                        }
                    }
                }
            }
            Button {
                text : "PLOT";
                onClicked : Julia.my_function(jdisp, jdisp.width, jdisp.height)
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
                        onClicked: { split = checked;}
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
        Row {

            Repeater {
                model: _selectvalues
                Column {
                    //Text { text: name }
                    Text {
                        text : name;
                        //checked : false;
                        //checkable : true;
                        //onClicked: { split = checked;}
                    }
                    Repeater {
                        model: _values
                        SpinBox {
                            minimumValue: min_value
                            maximumValue: max_value
                            value: selected_value;
                            onEditingFinished : {selected_value = value}
                        }
                    }
                }
            }
        }
        JuliaDisplay {
            id: jdisp
            width: 800; height: 500
        }
        TextField{
            placeholderText: "insert keywords here"
            width: 800
            onEditingFinished : {choose.value = text}
        }
    }

}
