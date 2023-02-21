import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.2
import QtQuick.LocalStorage 2.0 as SQL

Item {
    id: item1
    width: 480
    height: 620
    anchors.fill: parent
    function request(input) {
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
                if (Object.keys(zwrota.success).length > 0) {
                    text2.visible = false
                    for (var i=0; i < Object.keys(zwrota.success).length; i++)
                        przystankiLista.append({
                        symbol:zwrota.success[i].symbol, name:zwrota.success[i].name
                    })
                } else {
                    text2.visible = true
                    text2.text = "Nie znaleziono pasujących przystanków."
                }
            }
        }

        var data = "method=getStopPoints&p0=%7B%22pattern%22%3A%22"+input+"%22%7D";

        xhr.send(data);
    }

    Component.onCompleted: {
        function showdatabase() {
            var db = SQL.LocalStorage.openDatabaseSync(
                "baza_przystanki", "1.0",
                "Baza danych z wyszukanymi przystankami", 1000000)
            db.transaction(function (tx) {
                var rs = tx.executeSql(
                    'SELECT * FROM Przystanki ORDER BY Kolejnosc DESC')
                for (var i=0; i < rs.rows.length; i++) {
                    bazaprzystanki.append({
                        namee:rs.rows.item(i).nazwa,
                    })
                    console.log(rs.rows.item(i).nazwa)
                }
            })
        }
        showdatabase()
    }

    Rectangle {
        id: rectangle1
        color: "#b7b7b7"
        anchors.fill: parent

        Text {
            id: text2
            y: 82
            visible: false
            color: "#ff0000"
            text: qsTr("Text")
            font.pixelSize: 16
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    ListModel {
        id: przystankiLista
    }

    ListModel {
        id: bazaprzystanki
    }

    ListView {
        id: listViewBaza
        y: 104
        width: parent.width
        height: 100
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 31
        anchors.leftMargin: 31
        delegate: Item {
            id: item2
            width: parent.width
            height: 30
            Row {
                id: row
                width: parent.width
                height: 20
                Rectangle {
                    id: rectangleee
                    color: "#003af9"
                    border.color: "#481313"
                    anchors.fill: parent
                    radius: 10

                    Text {
                        id: sT
                        color: "#ffffff"
                        text: namee
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 15
                        anchors.leftMargin: 20
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: stack.push("Lines.qml", {
                            "stopPoint":sT.text
                        })
                    }

                    Rectangle {
                        id: sTrecdd
                        width: 50
                        height: parent.height
                        radius: 10
                        border.color: "#481313"
                        anchors.right: parent.right
                        anchors.rightMargin: 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                function usunprzystanki(nazwa) {
                                    var db = SQL.LocalStorage.openDatabaseSync (
                                        "baza_przystanki", "1.0",
                                        "Baza danych z wyszukanymi przystankami",
                                        1000000)
                                    db.transaction(function (tx) {
                                        tx.executeSql(
                                            'DELETE FROM Przystanki WHERE nazwa = ?',
                                            [nazwa])
                                    })
                                }
                                usunprzystanki(sT.text)
                                stack.push("MainView.qml")
                            }
                        }

                        Text {
                            id: sTe
                            text: "X"
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
        model: bazaprzystanki
    }


    ListView {
        id: listView
        y: 218
        height: 394
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 31
        anchors.leftMargin: 31
        delegate: Item {
            id: item3
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
                            id: sTdss
                            text: symbol
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Text {
                        id: nazwa
                        color: "#ffffff"
                        text: name
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAnywhere
                        anchors.horizontalCenter: parent.horizontalCenter
                        padding: 5
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            function przystankibaza(przys) {
                                var db = SQL.LocalStorage.openDatabaseSync(
                                    "baza_przystanki", "1.0",
                                    "Baza danych z wyszukanymi przystankami",
                                    1000000)
                                db.transaction(function (tx) {
                                    tx.executeSql(
                                        'CREATE TABLE IF NOT EXISTS Przystanki(Kolejnosc TEXT, nazwa TEXT)')
                                    var id = tx.executeSql(
                                        'SELECT * FROM Przystanki')
                                    var dlugosc = id.rows.length
                                    tx.executeSql(
                                        'INSERT INTO Przystanki VALUES(?, ?)',
                                        [dlugosc + 1, przys])
                                })
                            }
                            console.log(name)

                            stack.push("Lines.qml", {
                                "stopPoint":nazwa.text
                            })
                            przystankibaza(nazwa.text)
                        }
                    }
                }
            }
        }
        model: przystankiLista
    }

    Rectangle {
        id: rectanglee
        y: 40
        width: 275
        height: 40
        color: "#003dff"
        radius: 5
        border.width: 4
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40

        TextInput {
            id: textInput
            y: 0
            height: 40
            color: "#ffffff"
            text: qsTr("")
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            onTextChanged: {
                if (this.text.length > 3) {
                    przystankiLista.clear()
                    request(this.text)
                } else {
                    przystankiLista.clear()
                }
            }
        }
    }

    Text {
        id: text1
        y: 13
        height: 18
        text: qsTr("Wprowadź nazwę przystanku:")
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        anchors.horizontalCenter: parent.horizontalCenter
    }

}