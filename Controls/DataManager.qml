import QtQuick 2.15

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Sql 1.0

import Esri.ArcGISRuntime 100.11;

Item {
    id: dataManager

    property string trackId: ""

    property real distance: 0

    property var lastPointObj

    property var pointsArr: []

    property var geometry: ({})
    property var metadata: ({})

    AppDb {
        id: db

        function init() {
            exec("PRAGMA foreign_keys = ON;");

            exec("CREATE TABLE IF NOT EXISTS Tracks (TrackId TEXT UNIQUE, Geometry TEXT, Metadata TEXT");
            exec("CREATE TABLE IF NOT EXISTS Points (TrackId TEXT, Timestamp NUMBER, Latitude NUMBER, Longitude NUMBER, Altitude NUMBER, Metadata TEXT, FOREIGN KEY(TrackId) REFERENCES Tracks(TrackId) ON UPDATE CASCADE ON DELETE CASCADE)");
        }

        function sqlQuery(string) {
            let q = db.query();
            q.prepare(string);

            return q;
        }
    }

    FileFolder {
        id: folder

        function create() {
            path = "~/ArcGIS/%1".arg("SpeedTracker");
            makeFolder();

            if (!fileExists(".nomedia") && app.deviceManager.isAndroid)
                writeFile(".nomedia", "");
        }
    }

    function init() {
        folder.create();

        db.create(folder.filePath("db.sqlite"));
        db.init();
    }

    function startCapture(position, callback) {
        reset();

        trackId = AppFramework.createUuidString(0).toUpperCase();

        let timestamp = getTimestamp();

        let coordinate = position.coordinate;
        let y = coordinate.latitude;
        let x = coordinate.longitude;
        let z = coordinate.altitude;

        let pointObj = ArcGISRuntimeEnvironment.createObject("Point", {
                                                                 x: x,
                                                                 y: y,
                                                                 z: z,
                                                                 spatialReference: Factory.SpatialReference.createWgs84()
                                                             });

        lastPointObj = pointObj;

        let point = [x, y, z];

        pointsArr = [point];

        geometry = {
            hasZ: true,
            paths: [pointsArr],
            spatialReference: {
                wkid: kWGS84
            }
        };

        metadata = {
            startTime: timestamp,
            endTime: "N/A",
            distance: 0,
            avgSpeed: 0
        };

        db.exec(queries.tracks.insert, {
                    trackId: trackId,
                    geometry: JSON.stringify(geometry),
                    metadata: JSON.stringify(metadata)
                });

        db.exec(queries.points.insert, {
                    trackId: trackId,
                    timestamp: timestamp,
                    latitude: y,
                    longitude: x,
                    altitude: z
                });

        callback({
                     geometry: geometry,
                     pointObj: pointObj
                 });
    }

    function trackCapture(position, callback) {
        let timestamp = getTimestamp();

        let coordinate = position.coordinate;
        let y = coordinate.latitude;
        let x = coordinate.longitude;
        let z = coordinate.altitude;

        let pointObj = ArcGISRuntimeEnvironment.createObject("Point", {
                                                                 x: x,
                                                                 y: y,
                                                                 z: z,
                                                                 spatialReference: Factory.SpatialReference.createWgs84()
                                                             });

        let step = GeometryEngine.distance(GeometryEngine.project(pointObj, Factory.SpatialReference.createWebMercator()),
                                           GeometryEngine.project(lastPointObj, Factory.SpatialReference.createWebMercator()));

        distance += step;

        lastPointObj = pointObj;

        let point = [x, y, z];

        pointsArr.push(point);

        geometry.paths = [pointsArr];

        let elapsedSeconds = (metadata.startTime - timestamp) / 1000;

        metadata.avgSpeed = distance / elapsedSeconds;
        metadata.endTime = timestamp;
        metadata.distance = distance;

        db.exec(queries.tracks.update, {
                    trackId: trackId,
                    geometry: JSON.stringify(geometry),
                    metadata: JSON.stringify(metadata)
                });

        db.exec(queries.points.insert, {
                    trackId: trackId,
                    timestamp: timestamp,
                    latitude: y,
                    longitude: x,
                    altitude: z
                });

        callback({
                     geometry: geometry,
                     pointObj: pointObj
                 });
    }

    function endCapture(position, callback) {
        let coordinate = position.coordinate;
        let y = coordinate.latitude;
        let x = coordinate.longitude;
        let z = coordinate.altitude;

        let pointObj = ArcGISRuntimeEnvironment.createObject("Point", {
                                                                 x: x,
                                                                 y: y,
                                                                 z: z,
                                                                 spatialReference: Factory.SpatialReference.createWgs84()
                                                             });

        let step = GeometryEngine.distance(GeometryEngine.project(pointObj, Factory.SpatialReference.createWebMercator()),
                                           GeometryEngine.project(lastPointObj, Factory.SpatialReference.createWebMercator()));

        distance += step;

        lastPointObj = pointObj;

        let point = [x, y, z];

        pointsArr.push(point);

        let count = pointsArr.count;

        if (count < 2) {
            reset();

            db.exec(queries.tracks._delete, {
                        trackId: trackId
                    });

            return;
        }

        geometry.paths = [pointsArr];

        let elapsedSeconds = (metadata.startTime - timestamp) / 1000;

        metadata.avgSpeed = distance / elapsedSeconds;
        metadata.endTime = timestamp;
        metadata.distance = distance;

        db.exec(queries.tracks.update, {
                    trackId: trackId,
                    geometry: JSON.stringify(geometry),
                    metadata: JSON.stringify(metadata)
                });

        db.exec(queries.points.insert, {
                    trackId: trackId,
                    timestamp: timestamp,
                    latitude: y,
                    longitude: x,
                    altitude: z
                });

        callback({
                     geometry: geometry,
                     pointObj: pointObj
                 });
    }

    function getTimestamp() {
        let date = new Date();

        return date.getTime();
    }

    function reset() {
        trackId = "";
        lastPointObj = null;
        distance = 0;
        pointsArr = [];
        geometry = {};
        metadata = {};
    }
}
