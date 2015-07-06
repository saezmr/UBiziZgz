WorkerScript.onMessage = function(sentMessage) {
    var apiKey = sentMessage.apiKey;
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var parsedMsg;
    var stations = [];

    xmlHttp.open("GET", "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/estacion-bicicleta.json?start=0&rows=130", true);

    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;
            //console.log("Respuesta: "+msg);
            // Parse response text to usable object.
            parsedMsg = JSON.parse(msg);
            //console.log("parseado -> :"+parsedMsg);
            if (typeof parsedMsg != "undefined") {
                //console.log("bien parseado");
                for (var i = 0; i < parsedMsg.result.length; i++) {
                    //console.log("puss station:"+parsedMsg.result[i]);
                    stations.push(parsedMsg.result[i]);
                }
                stations.sort(compare);
                //console.log("estaciones ordenadas:"+stations);
                WorkerScript.sendMessage({'stations': stations});
            }
        }
    }
}

function compare(a, b) {
    //console.log(a.title+"-"+b.title);
    if (a.title < b.title)
        return -1;
    if (a.title > b.title)
        return 1;

    return 0;
}
