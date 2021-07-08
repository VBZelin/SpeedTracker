import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12

import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.11

import "../Widgets"

Item {
    id: mainUI

    anchors.fill: parent

    property int currentSpeed: 78
    property bool isStarted: false

    Rectangle {
        anchors.fill: parent

        color: colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: app.isiOS ? app.topNotchHeight : 0
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 48 * scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: width * 0.8

            Speedometer{
                anchors.fill: parent
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 100 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: currentSpeed
                font.pixelSize: 88 * scaleFactor
                font.bold: true
                color: colors.theme

                wrapMode: Text.Wrap

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20 * scaleFactor

            Label {
                width: parent.width
                height: parent.height

                text: strings.speed_units
                font.pixelSize: 16 * scaleFactor
                color: colors.white_90

                wrapMode: Text.Wrap

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 94 * scaleFactor

            GridLayout {
                id: grid

                width: 296 * scaleFactor
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3

                columnSpacing: 0

                BlockDelegate {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    blockTitle: strings.duration
                    numberContent: "1:39"
                    blockUnits: strings.duration_units
                }

                BlockDelegate {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    blockTitle: strings.average_speed
                    numberContent: "90"
                    blockUnits: strings.speed_units
                }

                BlockDelegate {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    blockTitle: strings.distance
                    numberContent: "114"
                    blockUnits: strings.distance_units
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 42 * scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60 * scaleFactor

            RowLayout {
                width: 296 * scaleFactor
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Rectangle {
                    Layout.preferredWidth:  60 * scaleFactor
                    Layout.fillHeight: true

                    color: colors.white_15
                    radius: 60 * scaleFactor


                    Image {
                        id:mapView

                        width: 36 * scaleFactor
                        height: width
                        source: images.map_thumbnail
                        mipmap: true
                        anchors.centerIn: parent
                    }

                    ColorOverlay {
                        anchors.fill: mapView
                        source: mapView
                        color: colors.white
                    }
                }

                Item {
                    Layout.preferredWidth:  46 * scaleFactor
                    Layout.fillHeight: true
                }

                Rectangle {
                    visible: isStarted
                    Layout.preferredWidth: 188 * scaleFactor
                    Layout.fillHeight: true

                    border.width: 3 * scaleFactor
                    color: colors.transparent
                    border.color: colors.theme
                    radius: 30 * scaleFactor

                    Label {
                        id: stopLabel

                        width: parent.width
                        height: parent.height
                        clip: true

                        text: strings.stop
                        color: colors.theme
                        font.pixelSize: 24 * scaleFactor
                        font.bold:true
                        elide: Text.ElideLeft

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    TouchGestureArea {
                        anchors.fill: parent

                        radius: 20 * scaleFactor
                        color: colors.transparent

                        onClicked:{
                        }
                    }
                }

                Rectangle {
                    visible: !isStarted
                    Layout.preferredWidth: 188 * scaleFactor
                    Layout.fillHeight: true

                    color: colors.theme
                    radius: 30 * scaleFactor

                    Label {
                        id: startLabel

                        width: parent.width
                        height: parent.height
                        clip: true

                        text: strings.start
                        color:  colors.white
                        font.pixelSize: 24 * scaleFactor
                        font.bold:true
                        elide: Text.ElideLeft

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    TouchGestureArea {
                        anchors.fill: parent

                        radius: 20 * scaleFactor
                        color: colors.transparent

                        onClicked:{
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 40 * scaleFactor
        }
    }
}
