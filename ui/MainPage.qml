import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import QtLocation 5.0
import QtPositioning 5.2
import QtQuick.XmlListModel 2.0

Page {
    id: mainPage

    title: i18n.tr("UBiziZgz")

    // Always begin by loading the selected stop.
    Component.onCompleted: {
        queryStationsWorker.sendMessage({"station": stationsModel.get(stationSelector.selectedIndex).name})
    }

    WorkerScript {
        id: queryBikesWorker
        source: "../js/getbikes.js"

        onMessage: {
            bikesAvailableLabel.font.pointSize = 28;
            bikesAvailableLabel.text = "<b>" + messageObject.stationInfo.available_bikes + "</b><br>Bikes";

            spotsAvailableLabel.font.pointSize = 28;
            spotsAvailableLabel.text = "<b>" + messageObject.stationInfo.available_bike_stands + "</b><br>Spots";

            map.center = QtPositioning.coordinate(messageObject.stationInfo.position.lat, messageObject.stationInfo.position.lng)
            map.zoomLevel = 16

            activityIndicator.running = false
        }
    }

    WorkerScript {
        id: queryStationsWorker
        source: "../js/getstations.js"

        onMessage: {
            for (var i = 0; i < messageObject.stations.length; i++) {
                stationsModel.append({ "name": messageObject.stations[i].title, "description": "" })
            }

            stationSelector.selectedIndex = getLastStationIndex(lastStation.contents.id, stationsModel)
        }
    }

    head.actions: [
        Action {
            id: reloadAction

            iconName: "reload"
            text: "Reload"

            onTriggered: {
                activityIndicator.running = true
                queryBikesWorker.sendMessage({"station": stationsModel.get(stationSelector.selectedIndex).name})
            }
        },
        Action {
            id: aboutAction

            iconName: "info"
            text: "About"

            onTriggered: PopupUtils.open(aboutPopover)
        }
    ]

    AboutPopover {
        id: aboutPopover
    }

    Item {
        id: selectStationRow

        Label {
            id: selectStationLabel

            text: "<b>Select Station:</b>"
        }

        ActivityIndicator {
            id: activityIndicator

            anchors.right: parent.right

            y: selectStationLabel.y - 6
        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(2)
            margins: units.gu(2)
        }
    }

    Row {
        id: stationRow

        spacing: -20

        anchors {
            top: selectStationRow.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(4)
            margins: units.gu(2)
        }

        OptionSelector {
            id: stationSelector
            containerHeight: units.gu(21.5)
            expanded: false
            model: stationsModel

            delegate: OptionSelectorDelegate {
                text: name
                subText: description
            }

            onSelectedIndexChanged: {
                activityIndicator.running = true
                queryBikesWorker.sendMessage({'station': stationsModel.get(stationSelector.selectedIndex).name})

                // Save station to U1DB backend for faster access on next app start.
                lastStation.contents = {id: stationsModel.get(stationSelector.selectedIndex).id}
            }
        }

        ListModel {
            id: stationsModel

            ListElement { name: "Select a station..."; description: ""; }
        }
    }

    Row {
        id: availabilityRow

        spacing: 5

        anchors {
            left: parent.left
            right: parent.right
            top: stationRow.bottom
            topMargin: units.gu(2)

            margins: units.gu(2)
        }

        UbuntuShape {
            id: bikesAvailable
            width: parent.width / 2
            height: units.gu(13)
            radius: "medium"
            color: "#7dc242"

            Label {
                id: bikesAvailableLabel
                text: ""
                color: "white"

                anchors.centerIn: parent
            }
        }

        UbuntuShape {
            id: spotsAvailable
            width: parent.width / 2
            height: units.gu(13)
            radius: "medium"
            color: "#add8e6"

            Label {
                id: spotsAvailableLabel
                text: ""
                color: "white"

                anchors.centerIn: parent
            }
        }
    }

    Item {
        id: mapRow

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: availabilityRow.bottom

            topMargin: units.gu(1)
            margins: units.gu(1)
        }

        Map {
            id: map

            anchors {
                fill: parent
            }

            center: QtPositioning.coordinate(53.351, -6.260)
            zoomLevel: 15

            plugin: Plugin {
                id: plugin
                allowExperimental: true
                preferred: ["nokia", "osm"]
                required.mapping: Plugin.AnyMappingFeatures
                required.geocoding: Plugin.AnyGeocodingFeatures

                parameters: [
                    PluginParameter { name: "app_id"; value: apiKeys.here_app_id },
                    PluginParameter { name: "token"; value: apiKeys.here_token }
                ]
            }

            XmlListModel {
                id: bikeStationModel

                source: "www.zaragoza.es/api/recurso/urbanismo-infraestructuras/estacion-bicicleta.xml?start=0&rows=130"
                query: "/resultado/result/estacion"

                XmlRole { name: "id";  query: "id/string()";  isKey: true }
                XmlRole { name: "title";   query: "title/string()";   isKey: true }
                XmlRole { name: "estado";   query: "estado/string()";   isKey: true }
                XmlRole { name: "bicisDisponibles"; query: "bicisDisponibles/string()"; isKey: true }
                XmlRole { name: "anclajesDisponibles";  query: "anclajesDisponibles/string()";  isKey: true }
                //es posible que haya que trocear esto en dos, ya que por desgracia viene en un solo campo
                XmlRole { name: "coordinates";  query: "geometry/coordinates/string()";  isKey: true }
            }

            MapItemView  {
                model: bikeStationModel
                delegate: MapQuickItem {
                    id: poiItem
                    coordinate: QtPositioning.coordinate(coordinates)//aqui habria que pasar lat, long

                    anchorPoint.x: poiImage.width * 0.5
                    anchorPoint.y: poiImage.height

                    sourceItem: Image {
                        id: poiImage
                        width: units.gu(3)
                        height: units.gu(3)

                        source: "../img/place_icon.svg"

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                PopupUtils.open(bikeStationPopover)
                                stationSelector.selectedIndex = getLastStationIndex(id, stationsModel)
                            }
                        }

                        BikeStationPopover {
                            id: bikeStationPopover
                        }
                    }
                }
            }
        }
    }
}
