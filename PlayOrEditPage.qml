import QtQuick 2.0
import QtQuick.Controls 2.15
import QtMultimedia 5.0

Item {
    id: playOrEditPage

    property string videoToPlay
    property bool edit
    property int shape_x: parent.width / 2
    property int shape_y: parent.height / 2
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
        source: videoToPlay
        loops: MediaPlayer.Infinite

        MouseArea {
            anchors.fill: parent
            onClicked: {
                videoPlayEdit.playbackState == MediaPlayer.PlayingState ? videoPlayEdit.pause() : videoPlayEdit.play()
            }

        }
        Text {
            id: txtNumerical
            visible: chkNumerical.checked ? edit ? true : false : false
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
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
            visible: chkProgress.checked ? edit ? true : false : false
            x: 220
            y: 320
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
        x: parent.width - 200
        width: 200
        height: parent.height
        color: "#90000000"
        border.width: 0


        Timer {
            id: timerNumericalValue
            interval: 300; running: true; repeat: true
            onTriggered: txtNumerical.text = Math.ceil(Math.random()*100)
        }
        GroupBox {
            id: groupBox
            x: 32
            y: 8
            width: 160
            height: 128
            title: qsTr("Numerical")

            TextField {
                id: textField
                x: 0
                y: 53
                width: 136
                height: 40
                placeholderText: qsTr("Text Field")
            }

            CheckBox {
                id: chkNumerical
                x: -3
                y: 9
                width: 142
                height: 40
                text: qsTr("Numerical")
                checked: true
                onClicked: {
                    if (chkNumerical.checked)
                        timerNumericalValue.start()
                    else
                        timerNumericalValue.stop()
                }
            }
        }

        CheckBox {
            id: chkShape
            x: 68
            y: 150
            text: qsTr("Shape")
            checked: true
            onClicked: {
                if (chkShape.checked)
                    timerShape.start()
                else
                    timerShape.stop()
            }
        }

        CheckBox {
            id: chkProgress
            x: 63
            y: 276
            text: qsTr("Progress")
            checked: true
            onClicked: {
                if (chkProgress.checked)
                    timerProgress.start()
                else
                    timerProgress.stop()
            }
        }

        Timer {
            id: timerShape
            interval: 1000; running: true; repeat: true //TODO stavi interval na 1000 ms
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
                if (prgsBar.value == prgsBar.to){
                    increment = false
                }
                else if (prgsBar.value == prgsBar.from) {
                    increment = true
                }
                prgsBar.value = increment == true ? prgsBar.value + 1 : prgsBar.value - 1
            }
        }

        Button {
            id: button
            x: 68
            y: 418
            width: 115
            height: 40
            text: qsTr("Apply")
        }



    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
