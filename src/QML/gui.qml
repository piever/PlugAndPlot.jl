import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
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
                    TextField{
                        placeholderText: "specify operation"
                        visible: ask_info
                        onEditingFinished : {text_info = text}
                    }
                }
            }
            Column{
                Text{
                    text: "Smoothing"
                }
                Slider {
                    id: smoothing
                    width: 100
                    //value: 1.
                    updateValueWhileDragging: false
                    minimumValue: 0.
                    maximumValue: 100.
                    onValueChanged: {
                        smoother.value = value;
                        Julia.do_plot(jdisp, jdisp.width, jdisp.height)
                    }
                }
            }
            Column{
                Button {
                    text : "PLOT";
                    onClicked : Julia.do_plot(jdisp, jdisp.width, jdisp.height)
                }
                Button {
                    text : "PLOT";
                    onClicked : Julia.do_plot(jdisp, jdisp.width, jdisp.height)
                }
                Button {
                    text : "SAVE";
                    onClicked : saveDialog.open()
                }
            }
        }
        Row {

            Repeater {
                model: _selectlist
                Column {
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
                    Text {
                        text : name;
                    }
                    Repeater {
                        model: _values
                        SpinBox {
                            minimumValue: min_value;
                            maximumValue: max_value;
                            value: selected_value;
                            onEditingFinished : {selected_value = value}
                        }
                    }
                }
            }
        }
        JuliaDisplay {
            id: jdisp
            width: 600; height: 400
        }
        TextField{
            placeholderText: "insert keywords here"
            width: 600
            onEditingFinished : {
                choose.value = text;
                Julia.do_plot(jdisp, jdisp.width, jdisp.height)
            }
        }
    }
    FileDialog {
        id: saveDialog
        title: "Please choose a file"
        folder: shortcuts.home
        selectMultiple: false
        selectExisting: false
        onAccepted: {
            console.log("You chose: " + saveDialog.fileUrl)
            Julia.do_plot(jdisp, jdisp.width, jdisp.height, saveDialog.fileUrl)
            close()
        }
        onRejected: {
            console.log("Canceled")
            close()
        }
    }

}
