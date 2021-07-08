import QtQuick 2.15

Item {
    id: queries

    property alias tracks: tracks
    property alias points: points

    QtObject {
        id: tracks

        property string insert: "INSERT INTO Tracks (TrackId, Geometry, MetaData) VALUES (:trackId, :geometry, :metadata);"
        property string update: "UPDATE Tracks SET Geometry = :geometry, MetaData = :metadata WHERE TrackId = :trackId;"
        property string _delete: "DELETE FROM Tracks WHERE TrackId = :trackId;"
    }

    QtObject {
        id: points

        property string insert: "INSERT INTO Points (TrackId, Timestamp, Latitude, Longitude, Altitude) VALUES (:trackId, :timestamp, :latitude, :longitude, :altitude);"
        property string select: "SELECT * FROM Points WHERE TrackId = :trackId;"
        property string countAllWithTrackId: "SELECT COUNT(*) AS Count FROM Points WHERE TrackId = :trackId;"
    }
}
