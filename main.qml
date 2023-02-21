import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.2

Window {
    id: window
    width: 480
    height: 620
    visible: true
    title: qsTr("Live Tram Finder")

    StackView {
        id: stack
        initialItem: ("MainView.qml")
        anchors.fill: parent
    }
}
