import QtQuick 2.0
import Ubuntu.Components 1.1
import U1db 1.0 as U1db
import "ui"

MainView {
    id: mainView

    applicationName: "andpr.biziapp"
    property string version: "0.1"

    useDeprecatedToolbar: false

    //automaticOrientation: true

    width: units.gu(45)
    height: units.gu(78)

    PageStack {
        id: pageStack
        Component.onCompleted: push(mainPage)
        MainPage {
            id:mainPage
        }
    }

    ////////////////////
    ///  javascript  ///
    ////////////////////
    function getStationIndex(stationId, stationsModel) {
        for (var i = 0; i < stationsModel.count; i++) {
            if (stationId === stationsModel.get(i).id)
                return i;
        }

        return 0;
    }

    function setFavorite(stationId){
        console.log("favorito seleccionado:"+stationId);
        mainPage.preSelectedStationId= stationId;
        mainPage.lanzarTema(stationId)
    }

    function addToFavorites(stationId, name){
        //console.log("stationId:"+stationId+", name: "+name);
        if (stationId !== 'undefinded'){
            biziAppDB.putDoc({"fav": {"stationId": stationId, "name": name}});
        }
        console.log("add favorite succefull")
    }

   function deleteFavorite(docId){
       biziAppDB.deleteDoc(docId);
       console.log(docId+" deleted")
   }

    ////////////////////////
    ///  fin javascript  ///
    ////////////////////////

    //TODO Una opcion es meter todo el tema de persistencia en un FavoritoModel.qml
   // U1DB backend to record the last-picked station. Makes it faster for users to get information for their usual station.
    U1db.Database {
        id: biziAppDB;
        path: "UBiziApp.u1db"
    }

    U1db.Index {
       database: biziAppDB
       id: favIdx
       /* You have to specify in the index all fields you want to retrieve
          The query should return the whole document, not just indexed fields
          https://bugs.launchpad.net/u1db-qt/+bug/1271973 */
       expression: ["fav.stationId", "fav.name"]
   }
   U1db.Query {
       id: favoritesQuery
       index: favIdx
       //query: "*"
   }

}
