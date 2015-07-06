import QtQuick 2.0
import Ubuntu.Components 1.1
import U1db 1.0 as U1db
import "ui"

MainView {
    id: mainView

    applicationName: "andpr.bizizgz"
    property string version: "0.1"

    useDeprecatedToolbar: false

    //automaticOrientation: true

    width: units.gu(45)
    height: units.gu(78)

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


    PageStack {
        id: pageStack
        Component.onCompleted: push(mainPage)
        MainPage {
            id:mainPage
        }
    }

/*    // U1DB backend to record the last-picked station. Makes it faster for users to get information for their usual station.
    U1db.Database {
        id: db;
        path: "bizizgz.u1db"
    }

    U1db.Document {
       id: lastStation
       database: db
       docId: "lastStation"
       create: true
       defaults: {
           stationName: ""
       }
    }
*/
}
