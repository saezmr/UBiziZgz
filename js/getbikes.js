//.import "CoordinatesUtil.js" as CoordUtil

WorkerScript.onMessage = function(sentMessage) {
    var stationId = sentMessage.stationId;
    var xmlHttp = new XMLHttpRequest();
    //var zoneZgz = 30;//ZONE UTM ZARAGOZA
    var msg;
    var stationInfo;
	//url de la estacion en formato json, y con coordenadas wgs84
    var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/estacion-bicicleta/" + stationId+".json?srsname=wgs84";
    //console.log("getBikes:"+url);
    xmlHttp.open("GET", url, true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {

        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;
            //console.log("getBikes:"+msg);
            // Parse response text to usable object.
            stationInfo = JSON.parse(msg);

            if (typeof stationInfo != "undefined") {
                WorkerScript.sendMessage({'stationInfo': stationInfo});
            }
        }
    }
}


