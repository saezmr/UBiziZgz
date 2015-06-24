WorkerScript.onMessage = function(sentMessage) {
    var stationId = sentMessage.stationId;
    var xmlHttp = new XMLHttpRequest();
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
                WorkerScript.sendMessage({'stationInfo': stationInfo});
            }
        }
    }
}
