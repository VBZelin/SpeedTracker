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

    signal back()
    signal currentSpeedChanged(var speed)

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

            speedTimer.start();
        }
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
        id: speedTimer

        interval: 1000
        repeat: true

        onTriggered: {
            getCurrentSpeed();
        }
    }

    function zoomToLocation(){
        if (mapView.locationDisplay.started)
            return;

        mapView.locationDisplay.start();
        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
    }


    function getCurrentSpeed(){
        let newSpeed = mapView.locationDisplay.location.velocity * 2.23694;

        currentSpeedChanged(newSpeed);
    }

    function open() {
        visible = true;
    }

    function close() {
        visible = false;
    }
}
