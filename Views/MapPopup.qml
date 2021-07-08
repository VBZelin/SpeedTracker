import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtPositioning 5.15

import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.11

import "../Widgets"
Item {
    id: mapPopup

    visible: false

    anchors.fill: parent

    property url webMapUrl: "https://melbournedev.maps.arcgis.com/home/item.html?id=c13ec8570ed6403ab67729e932e70c69"

    property var lastLocation

    property var tempPolylineGraphicsOverlay
    property var polylineGraphicsOverlay

    property var polylineBuilder

    signal newLocation(var location)
    signal back()

    MapView {
        id:mapView

        anchors.fill: parent

        Map {
            id: map

            initUrl: webMapUrl
        }

        locationDisplay {
            positionSource: PositionSource {
                id: devicePositionSource
            }
        }

        Component.onCompleted: {
            zoomToLocation();

            locationTimer.start();
        }
    }

    SimpleLineSymbol {
        id: polylineSymbol

        width: 4 * scaleFactor

        style: Enums.SimpleLineSymbolStyleSolid
        color: colors.theme
        antiAlias: true
    }

    SimpleLineSymbol {
        id: tempPolylineSymbol

        width: 4 * scaleFactor

        style: Enums.SimpleLineSymbolStyleDash
        color: colors.theme
        antiAlias: true
    }

    Rectangle {
        width: 48 * scaleFactor
        height: width
        anchors.top: parent.top
        anchors.topMargin: 28 * scaleFactor
        anchors.left: parent.left
        anchors.leftMargin: 16 * scaleFactor

        radius: width / 2
        color: colors.white_60

        Image {
            id: image

            width: 36 * scaleFactor
            height: width
            anchors.centerIn: parent

            source: images.back_icon
            sourceSize: Qt.size(width, height)
            mipmap: true

            onStatusChanged: {
                if (status === Image.Error)
                    source = "";
            }
        }

        ColorOverlay {
            anchors.fill: image

            source: image
            color: colors.white
        }

        TouchGestureArea {
            anchors.fill: parent

            radius: parent.radius

            onClicked:{
                mapView.locationDisplay.stop();

                back();
            }
        }
    }

    Timer {
        id: locationTimer

        repeat: true

        onTriggered: {
            getLocation();
        }
    }

    Component.onCompleted: {
        syncAllGraphics();
    }

    function syncAllGraphics() {
        resetAllGraphicsOverlays();

        mapView.graphicsOverlays.append(polylineGraphicsOverlay);
        mapView.graphicsOverlays.append(tempPolylineGraphicsOverlay);
    }

    function startPolyRendering(obj) {
        resetAllGraphicsOverlays();

        let geometry = obj.geometry;

        polylineBuilder = ArcGISRuntimeEnvironment.createObject("PolylineBuilder", {
                                                                    geometry: ArcGISRuntimeEnvironment.createObject("Polyline", {
                                                                                                                        json: geometry
                                                                                                                    })
                                                                });

        let graphic = createGraphic(polylineBuilder.geometry, tempPolylineSymbol);

        tempPolylineGraphicsOverlay.graphics.append(graphic);
    }

    function trackPolyRendering(obj) {
        let pointObj = obj.pointObj;

        polylineBuilder.addPoint(pointObj);

        let graphic = tempPolylineGraphicsOverlay.graphics.get(0);

        graphic.geometry = polylineBuilder.geometry;
    }

    function endPolyRendering(pointObj) {
        tempPolylineGraphicsOverlay.graphics.remove(0);

        let graphic = createGraphic(polylineBuilder.geometry, polylineSymbol);

        polylineGraphicsOverlay.graphics.append(graphic);
    }

    function createGraphic(geometry, symbol) {
        let graphic = ArcGISRuntimeEnvironment.createObject("Graphic");

        graphic.geometry = geometry;
        graphic.symbol = symbol;

        return graphic;
    }

    function zoomToLocation(){
        if (mapView.locationDisplay.started)
            return;

        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
        mapView.locationDisplay.start();
    }


    function getLocation(){
        lastLocation = mapView.locationDisplay.location;

        newLocation(lastLocation);
    }

    function resetAllGraphicsOverlays() {
        if (tempPolylineGraphicsOverlay)
            tempPolylineGraphicsOverlay.graphics.clear();
        else
            tempPolylineGraphicsOverlay = ArcGISRuntimeEnvironment.createObject("GraphicsOverlay", {
                                                                                    renderingMode: Enums.GraphicsRenderingModeStatic
                                                                                });

        if (polylineGraphicsOverlay)
            polylineGraphicsOverlay.graphics.clear();
        else
            polylineGraphicsOverlay = ArcGISRuntimeEnvironment.createObject("GraphicsOverlay", {
                                                                                renderingMode: Enums.GraphicsRenderingModeStatic
                                                                            });

        polylineBuilder = {};
    }

    function open() {
        visible = true;
    }

    function close() {
        visible = false;
    }
}
