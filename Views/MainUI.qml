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
    property bool timerStarted: false

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
            Layout.preferredWidth: Math.min(parent.width, app.maximumScreenWidth) - 48 * scaleFactor
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            Speedometer{
                id: speedometer

                width: parent.width
                height: width
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ColumnLayout {
                width: parent.width
                anchors.bottom: speedometer.bottom
                anchors.bottomMargin: -height / 3
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Label {
                    Layout.alignment: Qt.AlignHCenter

                    text: currentSpeed
                    font.family: fonts.demi_fontFamily
                    font.pixelSize: 88 * scaleFactor
                    font.bold: true
                    font.letterSpacing: -0.3 * scaleFactor
                    color: colors.theme

                    wrapMode: Text.Wrap

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    antialiasing: true
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter

                    text: strings.speed_units
                    font.family: fonts.regular_fontFamily
                    font.pixelSize: 16 * scaleFactor
                    font.letterSpacing: -0.3 * scaleFactor
                    color: colors.white_90

                    wrapMode: Text.Wrap

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    antialiasing: true
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 94 * scaleFactor

            GridLayout {
                id: gridLayout

                width: 296 * scaleFactor
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                columns: 3
                columnSpacing: 0

                property real cellwidth: width / count

                property int count: 3

                BlockDelegate {
                    Layout.preferredWidth: gridLayout.cellwidth
                    Layout.fillHeight: true

                    title: strings.duration
                    value: "1:39"
                    unit: strings.duration_units
                }

                BlockDelegate {
                    Layout.preferredWidth: gridLayout.cellwidth
                    Layout.fillHeight: true

                    title: strings.average_speed
                    value: "90"
                    unit: strings.speed_units
                }

                BlockDelegate {
                    Layout.preferredWidth: gridLayout.cellwidth
                    Layout.fillHeight: true

                    title: strings.distance
                    value: "114"
                    unit: strings.distance_units
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 42 * scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 56 * scaleFactor

            RowLayout {
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Rectangle {
                    Layout.preferredWidth: 56 * scaleFactor
                    Layout.fillHeight: true

                    color: colors.white_15
                    radius: width / 2

                    Image {
                        id: image

                        width: 36 * scaleFactor
                        height: width
                        anchors.centerIn: parent

                        source: images.map_thumbnail
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

                        }
                    }
                }

                Item {
                    Layout.preferredWidth: 48 * scaleFactor
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.preferredWidth: 188 * scaleFactor
                    Layout.fillHeight: true

                    color: {
                        if (timerStarted)
                            return colors.transparent;

                        return colors.theme;
                    }

                    radius: 30 * scaleFactor

                    border.width: {
                        if (timerStarted)
                            return 3 * scaleFactor;

                        return 0;
                    }

                    border.color: {
                        if (timerStarted)
                            return colors.theme;

                        return colors.transparent;
                    }

                    Label {
                        width: parent.width
                        height: parent.height
                        clip: true

                        text: {
                            if (timerStarted)
                                return strings.stop;

                            return strings.start;
                        }

                        color: {
                            if (timerStarted)
                                return colors.theme;

                            return colors.white;
                        }

                        font.family: fonts.demi_fontFamily
                        font.pixelSize: 24 * scaleFactor
                        font.letterSpacing: -0.3 * scaleFactor
                        font.bold: true

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft

                        antialiasing: true
                    }

                    TouchGestureArea {
                        anchors.fill: parent

                        radius: parent.radius

                        onClicked:{
                            timerStarted = !timerStarted;
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 48 * scaleFactor + app.bottomNotchHeight
        }
    }
}
