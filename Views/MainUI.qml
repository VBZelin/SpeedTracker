import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Platform 1.0

import Esri.ArcGISRuntime 100.11

import "../Widgets"

Item {
    id: mainUI

    anchors.fill: parent

    property bool timerStarted: false

    property string duration: "0"

    property int elapsedSeconds: 0
    property int days: 0
    property int hours: 0
    property int minutes: 0

    property int curSpeed: 0
    property int avgSpeed: 0

    property real distance: 0

    onTimerStartedChanged: {
        if (timerStarted) {
            duration = "00:00";

            startCapture();

            return;
        }

        stopCapture();
    }

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
            Layout.preferredHeight: 32 * scaleFactor
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
                anchors.bottomMargin: -implicitHeight / 3
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Label {
                    Layout.alignment: Qt.AlignHCenter

                    text: curSpeed
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
                    value: duration

                    unit: {
                        if (days > 0)
                            return strings.days;

                        return strings.hours;
                    }
                }

                BlockDelegate {
                    Layout.preferredWidth: gridLayout.cellwidth
                    Layout.fillHeight: true

                    title: strings.average_speed
                    value: avgSpeed
                    unit: strings.speed_units
                }

                BlockDelegate {
                    Layout.preferredWidth: gridLayout.cellwidth
                    Layout.fillHeight: true

                    title: strings.distance
                    value: distance.toFixed(2)
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
                            if (checkLocationPermission())
                                mapPopup.open();
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
                        anchors.fill: parent

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
                            if(checkLocationPermission()){
                                timerStarted = !timerStarted;
                            }
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

    MapPopup {
        id: mapPopup

        anchors.fill: parent

        onBack: {
            close();
        }

        onNewLocation: {
            if (!app.dataManager.isCapturing)
                return;

            app.dataManager.trackCapture(location, (obj) => {
                                             let metadata = obj.metadata;

                                             distance = metadata.distance;
                                             avgSpeed = metadata.avgSpeed;
                                             curSpeed = metadata.curSpeed;

                                             trackPolyRendering(obj);
                                         });
        }
    }

    // timer
    Timer {
        id: displayTimer

        running: false
        repeat: true

        onTriggered: {
            elapsedSeconds += 1;

            duration = getDuration(elapsedSeconds);
        }
    }

    function startCapture() {
        reset();

        displayTimer.start();

        app.dataManager.startCapture(mapPopup.lastLocation, (obj) => {
                                         let metadata = obj.metadata;

                                         distance = metadata.distance;
                                         avgSpeed = metadata.avgSpeed;
                                         curSpeed = metadata.curSpeed;

                                         mapPopup.startPolyRendering(obj);
                                     });
    }

    function stopCapture() {
        displayTimer.stop();

        app.dataManager.endCapture(mapPopup.lastLocation, (obj) => {
                                       let metadata = obj.metadata;

                                       distance = metadata.distance;
                                       avgSpeed = metadata.avgSpeed;
                                       curSpeed = metadata.curSpeed;

                                       mapPopup.endPolyRendering(obj);
                                   });
    }

    function reset() {
        elapsedSeconds = 0;
        days = 0;
        hours = 0;
        minutes = 0;
        avgSpeed = 0;
        distance = 0;
    }

    function getDuration(seconds) {
        days = Math.floor(seconds / 24 / 60 / 60);

        let hoursLeft = Math.floor((seconds) - (days * 86400));

        hours = Math.floor(hoursLeft / 3600);

        let minutesLeft = Math.floor((hoursLeft) - (hours * 3600));

        minutes = Math.floor(minutesLeft / 60);

        let secondsLeft = seconds % 60;

        if (days > 0)
            return "%1:%2".arg(format(days)).arg(format(hours));

        if (hours > 0)
            return "%1:%2".arg(format(hours)).arg(format(minutes));

        return "%1:%2".arg(format(minutes)).arg(format(secondsLeft));
    }

    function format(num) {
        return (num < 10 ? "0" + num : num);
    }

    function checkLocationPermission(){
        if (app.isiOS || app.isAndroid) {
            if (Permission.checkPermission(Permission.PermissionTypeLocationWhenInUse) !== Permission.PermissionResultGranted)
                return false;
            else
                return true;
        } else
            return true;
    }
}
