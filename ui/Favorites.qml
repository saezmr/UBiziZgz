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

    UbuntuListView  {
        id:favoritesList
        //anchors.fill: parent
        clip: true
        model: favoritesModel
        delegate: favoriteDelegate
        header: bannercomponent

        footer: Rectangle {
            width: parent.width; height: 10;
            gradient: favoriteColors
        }
    }

    ListItem.Expandable{
        id: favoriteDelegate
		text: name
        expandedHeight: units.gu(30)
		onClicked: {
			setFavorite(stationId)
			pageStack.pop();//push(Qt.resolvedUrl("MainPage.qml"), {"bikesAvailableColor": "#FF0000"})
		}
		/*PullToRefresh indica la accion al hacer la accion de refresco (arrastrar hacia abajo). Por defecto no hace nada.
		PullToRefresh {
		   refreshing: uListView.model.status === XmlListModel.Loading
		   onRefresh: uListView.model.reload()
	    }*/
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

