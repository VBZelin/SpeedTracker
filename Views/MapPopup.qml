import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtPositioning 5.3

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.11

import "../Widgets"
Item {
    id: mapPopup

    property url webMapUrl: "https://melbournedev.maps.arcgis.com/home/item.html?id=c13ec8570ed6403ab67729e932e70c69"
    signal backBtnClicked()

    anchors.fill: parent

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
        }

    }

    Rectangle {
        width: 48 * scaleFactor
        height: width
        anchors.top: parent.top
        anchors.topMargin: 28 * scaleFactor
        anchors.left: parent.left
        anchors.leftMargin: 16 * scaleFactor


        color: colors.white_60
        radius: width / 2

        Image {
            id: image

            width: 36 * scaleFactor
            height: width
            anchors.centerIn: parent

            source: images.back_icon
            sourceSize.width: width
            sourceSize.height: height
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
                backBtnClicked();
            }
        }
    }

    function zoomToLocation(){
        if (!mapView.locationDisplay.started) {
            mapView.locationDisplay.start();
            mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
        }
    }
}
