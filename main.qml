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

    StackView{
        id: stackView
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("qrc:/MainView.qml")
    }
}
