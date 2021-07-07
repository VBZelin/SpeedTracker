import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3

import ArcGIS.AppFramework 1.0
import QtGraphicalEffects 1.0
import QtQuick.Extras 1.4
import Esri.ArcGISRuntime 100.10

import "../Widgets" as Widgets

Page {
    id: mainPage
    objectName: "mainPage"

    Material.background: colors.black

    property int currentSpeed: 78
    property string units: strings.speed_units

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 16 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 108 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: strings.current_speed
                wrapMode: Text.Wrap
                font.pixelSize: 24 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                color: colors.titleTextColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: app.height * 0.3

            Widgets.Speedometer{
                anchors.fill: parent
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 110 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: currentSpeed
                wrapMode: Text.Wrap
                font.pixelSize: 88 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                color: colors.themeColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * constants.scaleFactor

            Label {
                width: parent.width
                height: parent.height
                text: units
                wrapMode: Text.Wrap
                font.pixelSize: 16 * constants.scaleFactor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: colors.textColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 94 * constants.scaleFactor

            GridLayout {
                id: grid

//                anchors.fill: parent
                height: parent.height
                width: 296 * constants.scaleFactor
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3

                columnSpacing: 0

                BlockDelegate {
                    blockTitle: strings.duration
                    numberContent: "1:39"
                    blockUnits: strings.duration_units

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width/3
                }

                BlockDelegate {
                    blockTitle: strings.average_speed
                    numberContent: "90"
                    blockUnits: strings.speed_units

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width/3
                }

                BlockDelegate {
                    blockTitle: strings.distance
                    numberContent: "114"
                    blockUnits: strings.distance_units

                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width/3
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 42 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60 * constants.scaleFactor

            RowLayout {
                height: parent.height
                width: 296 * constants.scaleFactor
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth:  60 * constants.scaleFactor
                    color: colors.transparentColor
                    radius: 60 * constants.scaleFactor

                    MapView {
                        id:mapView
                        anchors.fill: parent
                        zoomByPinchingEnabled: false
                        magnifierEnabled: false
                        allowMagnifierToPanMap: false

                        Map {
                            id: map
                            initUrl: "https://melbournedev.maps.arcgis.com/home/item.html?id=c13ec8570ed6403ab67729e932e70c69"

                            Component.onCompleted: {
                                mapView.setViewpointScale(400000000);
                            }
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: opacityMask
                        }
                    }

                    OpacityMask {
                        id: opacityMask

                        anchors.fill: mapView
                        source: mapView
                        maskSource: Rectangle {
                            width: mapView.width
                            height: mapView.height
                            radius: 60 * constants.scaleFactor
                            visible: false // this also needs to be invisible or it will cover up the image
                        }
                    }
                }

                Item {
                    Layout.preferredWidth:  46 * constants.scaleFactor
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.preferredWidth: 188 * constants.scaleFactor
                    Layout.fillHeight: true

                    border.width: 3 * constants.scaleFactor
                    color: colors.transparentColor
                    border.color: colors.themeColor
                    radius: 30 * constants.scaleFactor
//                    opacity: dataServiceManager.isBusy ? 0.3 : 1

                    Label {
                        id: signOutLabel

                        width: parent.width
                        height: parent.height

                        text: strings.stop
                        color: colors.themeColor
                        font.pixelSize: 24 * constants.scaleFactor
                        font.bold:true
                        elide: Text.ElideLeft
                        clip: true

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Widgets.TouchGestureArea {
                        anchors.fill: parent
                        radius: 20 * constants.scaleFactor
                        color: colors.transparentColor

                        onClicked:{}
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 40 * constants.scaleFactor
        }
    }

}
