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
        //console.logs("favorito seleccionado:"+stationId);
        mainPage.preSelectedStationId= stationId;
        mainPage.obtenerInfoEstacion(stationId)
    }

    function addToFavorites(stationId, name){
        if (typeof stationId !== "undefined" && noExiste(stationId)){
            biziAppDB.putDoc({"fav": {"stationId": stationId, "name": name}});
            return true;
        } else {
            return false;
        }
    }

    function noExiste(stationId){
        var noExiste = true;
        var index = 0;
        while (typeof favoritosModel.get(index).docId !== "undefined"){
            var sFavorito = JSON.stringify(favoritosModel.get(index));
            var favorito= JSON.parse(sFavorito);
            if (typeof favorito.contents === "undefined"){
                continuar = false;
                break;
            } else if (favorito.contents.stationId === stationId){
                noExiste= false;
                break;
            }
            index++;
            if (index>20){
                break;
            }
        }
        //console.logs("noExiste:"+noExiste);
        return noExiste;
    }

   function deleteFavorite(docId){
       biziAppDB.deleteDoc(docId);
       //console.logs(docId+" deleted")
   }

    ////////////////////////
    ///  fin javascript  ///
    ////////////////////////


   ////////////////////
   ///   DATABASE   ///
   ////////////////////
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

   SortFilterModel {
       id:favoritosModel
       model: favoritesQuery
   }

}
