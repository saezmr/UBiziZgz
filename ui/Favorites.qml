import QtQuick 2.0
import Ubuntu.Components 1.1

Page{
    id:favoritesPage
    title: i18n.tr("UBiziZgz Favoritos")

    property color green1: "#558855";
    property color green2: "#228822";
    property color grey: "lightgrey";


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
            height: 40
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
                    setFavorite(stationId)
                    pageStack.pop();//push(Qt.resolvedUrl("MainPage.qml"), {"bikesAvailableColor": "#FF0000"})
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


//    StackView {
//        id: pageStack
//    }
}

