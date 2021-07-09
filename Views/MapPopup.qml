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

    property var pointGraphicsOverlay
    property var tempPolylineGraphicsOverlay
    property var polylineGraphicsOverlay

    property var polylineBuilder
    property var polylineGraphic

    // 0 off, 1 is recenter, 2 is navigation
    property int autoPanMode: 1

    property bool isAutoPanLocked: false

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

        onMousePressed: {
            isMousePressed = true;
        }

        onMouseReleased: {
            if (isMousePressed) {
                isAutoPanLocked = true;

                autoPanTimer.restart();

                isMousePressed = false;
            }
        }

        property bool isMousePressed: false

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

    PictureMarkerSymbol {
        id: pointSymbol

        width: 16 * scaleFactor
        height: 16 * scaleFactor
        offsetY: height / 2

        url: images.map_point
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

    Timer {
        id: autoPanTimer

        interval: 6000

        onTriggered: {
            if (autoPanMode !== 0 && isAutoPanLocked && !app.dataManager.isCapturing)
                resumePreviousAutoPanMode();
        }
    }

    Component.onCompleted: {
        syncAllGraphics();
    }

    function syncAllGraphics() {
        resetAllGraphicsOverlays();

        mapView.graphicsOverlays.append(pointGraphicsOverlay);
        mapView.graphicsOverlays.append(polylineGraphicsOverlay);
    }

    function startPolyRendering(data) {
        resetAllGraphicsOverlays();

        let pointGraphic = createGraphic(data.pointObj, pointSymbol);

        pointGraphicsOverlay.graphics.append(pointGraphic);

        polylineBuilder = ArcGISRuntimeEnvironment.createObject("PolylineBuilder", {
                                                                    geometry: ArcGISRuntimeEnvironment.createObject("Polyline", {
                                                                                                                        json: data.geometry
                                                                                                                    })
                                                                });

        polylineGraphic = createGraphic(polylineBuilder.geometry, polylineSymbol);

        polylineGraphicsOverlay.graphics.append(polylineGraphic);

        let envelope = app.dataManager.createEnvelope();

        mapView.setViewpointGeometryAndPadding(envelope, 48 * scaleFactor);
    }

    function trackPolyRendering(data) {
        polylineBuilder.addPoint(data.pointObj);

        polylineGraphic.geometry = polylineBuilder.geometry;

        let envelope = app.dataManager.createEnvelope();

        mapView.setViewpointGeometryAndPadding(envelope, 48 * scaleFactor);
    }

    function endPolyRendering(data) {
        polylineBuilder.addPoint(data.pointObj);

        polylineGraphic.geometry = polylineBuilder.geometry;

        let envelope = app.dataManager.createEnvelope();

        mapView.setViewpointGeometryAndPadding(envelope, 48 * scaleFactor);
    }

    function createGraphic(geometry, symbol) {
        let graphic = ArcGISRuntimeEnvironment.createObject("Graphic");

        graphic.geometry = geometry;
        graphic.symbol = symbol;

        return graphic;
    }

    function zoomToLocation() {
        if (mapView.locationDisplay.started)
            return;

        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
        mapView.locationDisplay.start();
    }

    function resumePreviousAutoPanMode() {
        turnOffDefaultZooming();

        changeAutoPanMode(autoPanMode);
    }

    function turnOffDefaultZooming() {
        if (mapView.locationDisplay.initialZoomScale !== 0)
            mapView.locationDisplay.initialZoomScale = 0;
    }

    function changeAutoPanMode(autoPanMode) {
        mapView.locationDisplay.autoPanMode = autoPanMode;
        mapView.locationDisplay.start();

        isAutoPanLocked = false;
    }

    function getLocation() {
        lastLocation = mapView.locationDisplay.location;

        newLocation(lastLocation);
    }

    function resetAllGraphicsOverlays() {
        if (pointGraphicsOverlay)
            pointGraphicsOverlay.graphics.clear();
        else
            pointGraphicsOverlay = ArcGISRuntimeEnvironment.createObject("GraphicsOverlay", {
                                                                             renderingMode: Enums.GraphicsRenderingModeStatic
                                                                         });

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

        polylineBuilder = null;
        polylineGraphic = null;
    }

    function open() {
        visible = true;
    }

    function close() {
        visible = false;
    }
}
