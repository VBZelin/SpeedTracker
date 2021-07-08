import QtQuick 2.15

import ArcGIS.AppFramework.Sql 1.0

SqlDatabase {
    id: sqlDb

    function create(path) {
        close();

        databaseName = path;

        open();
    }

    // fast query
    function exec(sql, ...params) {
        let q = sqlDb.query(sql, ...params);

        if (!q.isValid) {
            return {
                success: false,
                error: q.error
            }
        }

        if (!q.isSelect) {
            q.finish();

            return {
                success: true,
                error: {}
            }
        }

        let obj = {
            success: true,
            results: [],
            error: {}
        };

        let ok = q.first();

        while (ok) {
            obj.results.push(q.values);

            ok = q.next();
        }

        q.finish();

        return obj;
    }
}
