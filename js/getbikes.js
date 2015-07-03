.import "CoordinatesUtil.js" as CoordUtil

WorkerScript.onMessage = function(sentMessage) {
    var stationId = sentMessage.stationId;
    var xmlHttp = new XMLHttpRequest();
    var zoneZgz = 30;//ZONE UTM ZARAGOZA
    var msg;
    var stationInfo;

    xmlHttp.open("GET", "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/estacion-bicicleta/" + stationId, true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;

            // Parse response text to usable object.
            stationInfo = JSON.parse(msg);

            if (typeof stationInfo != "undefined") {

                //transformamos las coordenadas UTM del servicio a GEO (WGS84) que usa HereMaps
                var cX = stationInfo.geometry.coordinates[0];
                var cY = stationInfo.geometry.coordinates[0];
                var geoCord = CoordUtil.getGeoCoordinatesFromUtm(cx, cy, zoneZgz,'N');
                stationInfo.geometry.coordinates[0] = geoCord[0];
                stationInfo.geometry.coordinates[1] = geoCord[1];

                WorkerScript.sendMessage({'stationInfo': stationInfo});
            }
        }
    }
}

