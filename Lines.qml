import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.2

Item {
    id: item1
    width: 480
    height: 620
    anchors.fill: parent
    property string stopPoint

    function getDirections(stopPoint) {
        var timestamp = Date.now();
        console.log(timestamp);

        let directions = ""

        var url = "https://www.peka.poznan.pl/vm/method.vm?ts="+timestamp;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", url);

        xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                //console.log(xhr.status);
                //console.log(xhr.responseText);
                const zwrota = JSON.parse(xhr.responseText);
                if (zwrota.success.bollards.length > 0) {
                    for (var tagData of zwrota.success.bollards) {
                        var tagLines = "";
                        for (var lines of tagData.directions) {
                            tagLines += lines.lineName + " -> " + lines.direction + " | ";
                        }
                        kierunkiLista.append({
                            "stopTag": tagData.bollard.tag, "stopLinesForTag": tagLines
                        });
                    }
                }
            }
        }

        var data = "method=getBollardsByStopPoint&p0=%7B%22name%22%3A%22" + stopPoint + "%22%7D";

        xhr.send(data);
    }

    Component.onCompleted: getDirections(stopPoint);



    Rectangle {
        id: background
        color: "#b7b7b7"
        anchors.fill: parent
    }

    Text {
        id: text1
        y: 20
        text: qsTr(stopPoint)
        font.pixelSize: 15
        anchors.horizontalCenter: parent.horizontalCenter
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
        anchors.rightMargin: 30
        anchors.leftMargin: 30
        delegate: Item {
            id: item2
            width: parent.width
            height: 160
            anchors.left: parent.left
            Row {
                id: row1
                width: parent.width
                height: 150

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
                            text: stopTag
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stack.push("Directions.qml", {
                                "symbol":sT.text
                            })
                        }
                    }

                    Text {
                        id: text2
                        color: "#ffffff"
                        text: stopLinesForTag
                        anchors.fill: parent
                        font.pixelSize: 13
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAnywhere
                        padding: 5
                    }
                }
            }
        }
        model: kierunkiLista
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
            stack.push("MainView.qml")
        }
        background: Rectangle {
            color: "blue"
            radius: 10
            border.width: 2
        }
    }

}

/*##^##
Designer {
    D{i:0;width:480}D{i:5}D{i:4}D{i:12}
}
##^##*/