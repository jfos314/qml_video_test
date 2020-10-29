import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.0
import Qt.labs.platform 1.0

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt QML video")

    property string folderFullName: ""
    property int selectedRaw: -1

    Rectangle {
        id: rectangle
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }
            GradientStop {
                position: 1
                color: "#000000"
            }
        }
    }

    Label {
        text: qsTr("Select video filter")
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenterOffset: -32
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: folderFullName == "" ? false : true//btnPath.text == "Select folder path" ? false : true
    }

    Button {
        id: btnPath
        text: folderFullName == "" ? qsTr("Select folder path") : folderFullName
        anchors.verticalCenter: parent.verticalCenter
        flat: false
        anchors.verticalCenterOffset: -85
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: openFolderDialog.open()
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 23
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Button{
            id: btnRaw
            text: qsTr("Raw videos")
            enabled: folderFullName == "" ? false : true
            onClicked: {
                selectedRaw = 1
                videoList.editedOnly = false
            }
        }

        Button {
            id: btnEdited
            text: qsTr("Edited videos")
            enabled: folderFullName == "" ? false : true
            onClicked: {
                selectedRaw = 0
                videoList.editedOnly = true
            }
        }
    }

    VideoList {
        id: videoList
        y: 351
        height: parent.height * 0.3
        visible: selectedRaw == -1 ? false : true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }

    FolderDialog {
        id: openFolderDialog
        title: qsTr("Select video folder")
        folder: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
        onAccepted: {
            folderFullName = openFolderDialog.folder
            btnPath.text = folderFullName
            videoList.folderName = folderFullName
        }
    }
}
