WorkerScript.onMessage = function(sentMessage) {
    var apiKey = sentMessage.apiKey;
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var parsedMsg;
    var stations = [];
	//json y coordenadas wgs84
    xmlHttp.open("GET", "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/estacion-bicicleta.json?srsname=wgs84&start=0&rows=130", true);

    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;
            //console.log("Respuesta: "+msg);
            // Parse response text to usable object.
            parsedMsg = JSON.parse(msg);
            if (typeof parsedMsg != "undefined") {
                for (var i = 0; i < parsedMsg.result.length; i++) {
                    stations.push(parsedMsg.result[i]);
                }
                stations.sort(compare);
                WorkerScript.sendMessage({'stations': stations});
            }
        }
    }
}

function compare(a, b) {
    if (a.title < b.title)
        return -1;
    if (a.title > b.title)
        return 1;

    return 0;
}
