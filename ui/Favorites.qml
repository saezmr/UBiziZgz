import QtQuick 2.0
import "../ubuntuComponents"

Item{
    id:itemFavorites
    anchors.fill: parent

    property color green1: "#558855";
    property color green2: "#228822";
    property color grey: "lightgrey";

    WorkerScript {
        id: favoriteQueryBikesWorker
        source: "../js/getbikes.js"

        onMessage: {
            //TODO aqui hay que cambiar nombres y poner que navegue a el mapa pasando la info buena
            bikesAvailableLabel.font.pointSize = 28;
            bikesAvailableLabel.text = "<b>" + messageObject.stationInfo.available_bikes + "</b><br>Bikes";

            spotsAvailableLabel.font.pointSize = 28;
            spotsAvailableLabel.text = "<b>" + messageObject.stationInfo.available_bike_stands + "</b><br>Spots";

            map.center = QtPositioning.coordinate(messageObject.stationInfo.position.lat, messageObject.stationInfo.position.lng)
            map.zoomLevel = 16

            activityIndicator.running = false
        }
    }

    ListModel{
        id:favoritesModel
        ListElement { stationId:"101"; name: "Favorito uno"; description: ""; }
        ListElement { stationId:"102"; name: "Favorito dos"; description: ""; }
    }

    ListView {
        id:favoritesList
        anchors.fill: parent
        clip: true
        model: favoritesModel
        delegate: favoriteDelegate
        header: bannercomponent

        footer: Rectangle {
            width: parent.width; height: 10;
            gradient: favoriteColors
        }
    }

    Component {
        id: favoriteDelegate
        Item{
            width: favoritesList.width
            height: 20
            Rectangle {
                id: background
                x: 1; y: 1; width: parent.width - x*1; height: parent.height - y*1
                color: grey
                border.color: green2
                radius: 5
            }
            Text {
                id:favoriteTextList
                text: name
                x: 2; y: 2; width: background.width-20; height: background.height
            }
            ActivityIndicator {
                id: activityIndicator
                width:15
                height:15
                anchors.right: parent.right
                y: favoriteTextList.y
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    activityIndicator.running = true
                    favoriteQueryBikesWorker.sendMessage({'stationId': stationId})
                }
            }
        }
    }

    Component {     //instantiated when header is processed
        id: bannercomponent
        Rectangle {
            id: banner
            width: parent.width; height: 25
            gradient: favoriteColors
            border {color:  green1; width: 2}
            Text {
                anchors.centerIn: parent
                text: "Favoritos"
                color: "#FFFFFF"
                font.pixelSize: 20
            }
        }
    }

    Gradient {
        id: favoriteColors
        GradientStop { position: 0.0; color: green1}
        GradientStop { position: 0.66; color: green2}
    }
}

