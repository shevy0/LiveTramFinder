import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.2

Item {
    id: item1
    width: 480
    height: 620
    anchors.fill: parent
    property string symbol

    function getTimes(symbol) {
        var timestamp = Date.now();
        console.log(timestamp);

        var url = "https://www.peka.poznan.pl/vm/method.vm?ts="+timestamp;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", url);

        xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                const zwrota = JSON.parse(xhr.responseText);
                for (var i=0; i < Object.keys(zwrota.success.times).length; i++) {
                    kierunkiLista.append({
                        lineNumber:zwrota.success.times[i].line,
                        departure:zwrota.success.times[i].minutes,
                        direction:zwrota.success.times[i].direction
                    })

                }
            }
        }


        var data = "method=getTimes&p0=%7B%22symbol%22%3A%22"+symbol+"%22%7D";

        xhr.send(data);
    }

    Component.onCompleted:
    {
        getTimes(symbol)
    }

    Rectangle {
        id: rectangle1
        color: "#b7b7b7"
        anchors.fill: parent
    }

    ListModel {
        id: kierunkiLista
    }

    ListView {
        id: listView
        y: 70
        height: 538
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.leftMargin: 60
        delegate: Item {
            id: item2
            width: parent.width
            height: 100
            anchors.left: parent.left
            Row {
                id: row1
                width: parent.width
                height: 90

                Rectangle {
                    id: rectangle
                    color: "#003af9"
                    border.color: "#481313"
                    anchors.fill: parent
                    radius: 10

                    Rectangle {
                        id: sTrec
                        width: parent.width - 10
                        height: 25
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 5
                        anchors.topMargin: 5
                        radius: 10
                        border.color: "#481313"

                        Text {
                            id: sT
                            text: lineNumber
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Rectangle {
                        id: sTrecd
                        width: 70
                        height: 30
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 10
                        anchors.bottomMargin: 5
                        radius: 10
                        border.color: "#481313"
                        anchors.right: parent.right

                        Text {
                            id: sTe
                            text: departure + " min"
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Text {
                        id: text2
                        color: "#ffffff"
                        text: direction
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAnywhere
                        anchors.horizontalCenter: parent.horizontalCenter
                        padding: 5
                    }
                }
            }
        }
        model: kierunkiLista
    }

    Timer {
        id: timer
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            kierunkiLista.clear()
            getTimes(symbol)
        }
    }

    Button {
        id: button
        x: 8
        y: 8
        text: qsTr("<")
        anchors.left: parent.left
        anchors.leftMargin: 12
        width: 40
        height: 40
        padding: 10
        flat: false
        font.pointSize: 14
        onClicked:
        {
            stack.pop()
        }
        background: Rectangle {
            color: "blue"
            radius: 10
            border.width: 2
        }
    }

}