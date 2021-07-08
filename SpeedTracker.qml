/* Copyright 2020 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.


import QtQuick 2.15
import QtQuick.Controls 2.15

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Notifications 1.0
import ArcGIS.AppFramework.Platform 1.0
import Esri.ArcGISRuntime 100.11

import "Assets"
import "Controls"
import "Views"

App {
    id: app

    width: 375
    height: 750

    readonly property real windowScaleFactor: {
        const regex = /^(windows|unix|linux)$/;

        if (Qt.platform.os.match(regex))
            return AppFramework.displayScaleFactor;

        return 1;
    }

    readonly property real scaleFactor: AppFramework.displayScaleFactor

    property real maximumScreenWidth: {
        if (width > 1000 * scaleFactor)
            return 800 * scaleFactor;

        return 568 * scaleFactor;
    }

    readonly property bool isDesktop: isWindows || isOSX || isLinux
    readonly property bool isWindows: Qt.platform.os === "windows"
    readonly property bool isOSX: Qt.platform.os === "osx"
    readonly property bool isLinux: Qt.platform.os === "linux"
    readonly property bool isiOS: Qt.platform.os === "ios"
    readonly property bool isAndroid: Qt.platform.os === "android"

    property bool isHapticFeedbackSupported: false
    property bool isiPhone: false
    property bool iPhoneNotchAvailable: false
    property bool iPadNotchAvailable: false

    property real topNotchHeight: {
        if (iPhoneNotchAvailable)
            return 40 * scaleFactor;

        return 20 * scaleFactor;
    }

    property real bottomNotchHeight: {
        if (iPhoneNotchAvailable || iPadNotchAvailable)
            return 16 * scaleFactor;

        return 0;
    }

    property var unixMachine

    property bool isRightToLeft: AppFramework.localeInfo().esriName === "ar" || AppFramework.localeInfo().esriName === "he"

    property alias dataManager: dataManager

    DataManager {
        id: dataManager
    }

    MainUI {
        id: mainUI
    }

    Colors {
        id: colors
    }

    Constants {
        id: constants
    }

    Fonts {
        id: fonts
    }

    Images {
        id: images
    }

    Queries {
        id: queries
    }

    Strings {
        id: strings
    }

    PermissionDialog {
        id:permissionDialog
        openSettingsWhenDenied: true

        onRejected:{}
        onAccepted:{}
    }

    Component.onCompleted: {
        init();
    }

    function init() {
        checkDevice();
        grantLocationPermission();
    }

    function checkDevice() {
        isHapticFeedbackSupported = HapticFeedback.supported;

        let unixName = AppFramework.systemInformation.unixMachine;

        if (typeof unixName === "undefined")
            return;

        unixMachine = unixName;

        if (unixMachine.match(/^iPhone/))
            isiPhone = true;

        switch (unixName) {
        case "iPhone10,3":
        case "iPhone10,6":
        case "iPhone11,2":
        case "iPhone11,4":
        case "iPhone11,6":
        case "iPhone11,8":
        case "iPhone12,1":
        case "iPhone12,3":
        case "iPhone12,5":
        case "iPhone13,1":
        case "iPhone13,2":
        case "iPhone13,3":
        case "iPhone13,4":
            iPhoneNotchAvailable = true;

            break;

        case "iPad8,1":
        case "iPad8,2":
        case "iPad8,3":
        case "iPad8,4":
        case "iPad8,5":
        case "iPad8,6":
        case "iPad8,7":
        case "iPad8,8":
        case "iPad8,9":
        case "iPad8,10":
        case "iPad8,11":
        case "iPad8,12":
        case "iPad13,1":
        case "iPad13,2":
            iPadNotchAvailable = true;

            break;

        default:
            break;
        }
    }

    function grantLocationPermission() {
        if(isiOS || isAndroid) {
            if (Permission.checkPermission(Permission.PermissionTypeLocationWhenInUse) !== Permission.PermissionResultGranted){
                permissionDialog.permission = PermissionDialog.PermissionDialogTypeLocationWhenInUse;
                permissionDialog.open();
            }
        }
    }
}

