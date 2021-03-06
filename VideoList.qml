import QtQuick 2.0
import Qt.labs.folderlistmodel 2.2
import QtQuick.Controls 2.15
import QtMultimedia 5.0

ListView {
    id: listView
    y: parent.height * 0.2
    height: parent.height * 0.2
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    spacing: 10
    leftMargin: 10
    rightMargin: 10
    anchors.rightMargin: 0
    anchors.leftMargin: 0
    anchors.bottomMargin: 0
    orientation: ListView.Horizontal

    property string folderName
    property bool editedOnly

    FolderListModel {
        id: folderModel
        showDirs: true
        showDirsFirst: true
        folder: folderName
        nameFilters: editedOnly ? ["*_edt.mp4", "*_edt.avi"] : ["*.mp4", "*.avi"]
    }

    Label {
        text: count == 0 ? qsTr("No videos in foder, please select some other") : ""
        enabled: folderFullName == "" ? false : true
        color: "white"
    }
    Component {
        id: fileDelegate
        Column {
            id: row1
            spacing: 10
            Row {
                spacing: 10
                Video {
                    id: videoPreview
                    width: listView.height * 0.5
                    height: listView.height * 0.5
                    autoPlay: true
                    source: folderName + "/" + fileName
                    onPlaying: {
                        videoPreview.seek(videoPreview.duration/2)
                        videoPreview.pause()
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push(Qt.resolvedUrl("qrc:/PlayOrEditPage.qml"), {"videoToPlayName":fileName, "videoToPlayPath":folderName, "edit": 0})
                    }
                }
                Image {
                    id: videoEditIcon
                    visible: editedOnly ? false : fileName.includes("_edt.") ? false : true
                    width: videoPreview.height * 0.5
                    height: videoPreview.height * 0.5
                    source: "video_edit_ico.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push(Qt.resolvedUrl("qrc:/PlayOrEditPage.qml"), {"videoToPlayName":fileName, "videoToPlayPath":folderName, "edit": 1})
                    }
                }
            }
            Text {
                text: fileName
                color: "white"
                font.bold: true
            }
        }
    }
    model: folderModel
    delegate: fileDelegate

}
