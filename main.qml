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

    Label {
        text: qsTr("Select video filter")
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenterOffset: -32
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: btnPath
        text: qsTr("Select folder path")
        anchors.verticalCenter: parent.verticalCenter
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
            onClicked: openFileDialog.open()
        }

        Button {
            id: btnEdited
            text: qsTr("Edited videos")
            onClicked: openFolderDialog.open()
        }
    }
    FolderDialog {
        id: openFolderDialog
        title: qsTr("Select video folder")
        folder: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
        onAccepted: {
            btnPath.text = openFolderDialog.folder
        }
    }
}
