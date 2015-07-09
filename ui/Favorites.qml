import QtQuick 2.0
import Ubuntu.Components 1.2

Page{
    id:favoritesPage
    title: i18n.tr("UBiziZgz Favoritos")

    property color green1: "#558855";
    property color green2: "#228822";
    property color grey: "lightgrey";

    UbuntuListView  {
        id:favoritesList
        width: units.gu(45)
        height: units.gu(80)
        clip:true
        model: favoritesQuery
        delegate: ListItem{
            Column{
                id:icono
                Icon{
                    width: units.gu(6)
                    height: units.gu(6)
                    name:"favorite-unselected"
                }
            }
            Column{
                anchors {
                    left: icono.rigth+units.gu(5)
                }
                Label{
                    //anchors.left:icono.right+units.gu(5)
                    text: contents.name
                    fontSize:"large"
                }
            }
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered:{
                            console.log("delete index:"+docId);
                            deleteFavorite(docId);
                        }
                    }
                ]
            }
            onClicked: {
                setFavorite(contents.stationId)
                pageStack.pop();
            }
        }
    }
   /* Scrollbar {
       flickableItem: favoritesList
       align: Qt.AlignTrailing
    }*/

}



