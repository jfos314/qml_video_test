import QtQuick 2.0
import QtQuick.Controls 2.15
import QtMultimedia 5.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

Item {
    id: playOrEditPage

    property string videoToPlayName
    property string videoToPlayPath
    property bool edit
    property int shape_x: videoPlayEdit.width * sldO2x.value
    property int shape_y: videoPlayEdit.height * sldO2y.value
    property color gradient_from
    property color gradient_to
    property bool increment: true

    Rectangle {
        id: rectBackground
        anchors.fill: parent
        color: "black"
    }
    Video {
        id: videoPlayEdit
        width: parent.width
        height: parent.height
        autoPlay: true
        source: videoToPlayPath + "/" + videoToPlayName
        loops: MediaPlayer.Infinite
        onStatusChanged: {
            if (status == MediaPlayer.EndOfMedia) {
                timerGraber.stop()
                stackView.pop()
            }
        }

        Text {
            id: txtNumerical
            x: videoPlayEdit.width * sldO1x.value
            y: videoPlayEdit.height * sldO1y.value
            visible: chkNumerical.checked ? edit ? true : false : false
            color: "white"
            wrapMode: Text.Wrap
        }
        Rectangle {
            id: rectMovingGradient
            x: shape_x
            y: shape_y
            visible: chkShape.checked ? edit ? true : false : false
            antialiasing: true
            width: 40
            height: 40
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: gradient_from
                }
                GradientStop {
                    position: 1
                    color: gradient_to
                }
            }
        }
        ProgressBar {
            id: prgsBar
            x: videoPlayEdit.width * sldO3x.value
            y: videoPlayEdit.height * sldO3y.value
            visible: chkProgress.checked ? edit ? true : false : false
            to: 10
        }
    }


    Button {
        text: qsTr("close")
        onClicked: stackView.pop()
    }

    Rectangle {
        id: recEditControls
        visible: edit ? true : false
        x: parent.width - 250
        width: 250
        height: parent.height
        color: "#90ffffff"
        border.width: 0
        ColumnLayout {
            spacing: 10
            anchors.centerIn: parent
            GroupBox {
                anchors.centerIn: parent.Center
                title: qsTr("Numerical")
                ColumnLayout {
                    CheckBox {
                        id: chkNumerical
                        text: qsTr("Numerical")
                        checked: true
                        onClicked: {
                            if (chkNumerical.checked) timerNumericalValue.start()
                            else timerNumericalValue.stop()
                        }
                    }
                    Slider {
                        id: sldO1x
                        value: 0.5
                    }
                    Slider {
                        id: sldO1y
                        value: 0.5
                    }
                }
            }
            GroupBox {
                anchors.left: parent.left
                title: qsTr("Shape")
                ColumnLayout {
                    CheckBox {
                        id: chkShape
                        text: qsTr("Shape")
                        checked: true
                        onClicked: {
                                if (chkShape.checked) timerShape.start()
                                else timerShape.stop()
                        }
                    }
                    Slider {
                        id: sldO2x
                        value: 0.5
                        onValueChanged: shape_x = videoPlayEdit.width * sldO2x.value
                    }
                    Slider {
                        id: sldO2y
                        value: 0.5
                        onValueChanged: shape_y = videoPlayEdit.width * sldO2y.value
                    }
                }
            }
            GroupBox {
                anchors.left: parent.left
                title: qsTr("Progress")
                ColumnLayout {
                    CheckBox {
                        id: chkProgress
                        text: qsTr("Progress")
                        checked: true
                        onClicked: {
                                if (chkProgress.checked) timerProgress.start()
                                else timerProgress.stop()
                        }
                    }
                    Slider {
                        id: sldO3x
                        value: 0.5
                    }
                    Slider {
                        id: sldO3y
                        value: 0.5
                    }
                }
            }
            Button {
                id: button
                text: qsTr("Apply")
                onClicked: {
                    videoPlayEdit.pause()
                    timerNumericalValue.stop()
                    timerProgress.stop()
                    timerShape.stop()
                    dialogProcessing.open()
                    exporter.export_video(videoToPlayPath + "/" + videoToPlayName,
                                chkNumerical.checked, 150, 100,
                                chkProgress.checked, 200, 400,
                                chkShape.checked, 500, 300)
                }
            }
        }
    }
    Dialog {
        id: dialogProcessing
        title: qsTr("Please wait...")
        standardButtons: Dialog.Ok
        Text {
            id: name
            text: qsTr("Finished")
        }
        onAccepted: stackView.pop()
    }
    Timer {
        id: timerNumericalValue
        interval: 300; running: true; repeat: true
        onTriggered: txtNumerical.text = Math.ceil(Math.random()*100)
    }
    Timer {
        id: timerShape
        interval: 1000; running: true; repeat: true
        onTriggered: {
            shape_x = shape_x < videoPlayEdit.width * 0.5 ? shape_x + (Math.random() * 50) : shape_x - (Math.random() * 50)
            shape_y = shape_y < videoPlayEdit.height * 0.5 ? shape_y + (Math.random() * 50) : shape_y - (Math.random() * 50)
            gradient_from.r = gradient_from.r + 10
            gradient_from.g = gradient_from.g + 20
            gradient_from.g = gradient_from.g + 30
            gradient_to.r = gradient_to.r - 10
            gradient_to.g = gradient_to.g - 20
            gradient_to.g = gradient_to.g - 30
        }
    }
    Timer {
        id: timerProgress
        interval: 500; running: true; repeat: true
        onTriggered: {
            if (prgsBar.value == prgsBar.to)
                increment = false
            else if (prgsBar.value == prgsBar.from)
                increment = true
            prgsBar.value = increment == true ? prgsBar.value + 1 : prgsBar.value - 1
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
