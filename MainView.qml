import QtQuick 2.0
import QtQuick.Controls 2.15
import Qt.labs.platform 1.0

Item {
    id: item1
    //id: mainView

    Rectangle {
        id: rectangle
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "white"
            }
            GradientStop {
                position: 1
                color: "black"
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
        enabled: folderFullName == "" ? false : true
    }

    Button {
        id: btnPath
        text: folderFullName == "" ? qsTr("Select folder") : folderFullName
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
