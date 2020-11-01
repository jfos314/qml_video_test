import QtQuick.Window 2.12
import QtQuick.Controls 2.15

Window {
    id: window
    width: 860
    height: 640
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
