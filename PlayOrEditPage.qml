import QtQuick 2.0
import QtQuick.Controls 2.15
import QtMultimedia 5.0

Item {
    id: playOrEditPage

    property string videoToPlay
    property bool edit

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

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
