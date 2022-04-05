const sql = require('mssql')

const config = {
    server: process.env.DB_HOST_SQL_SERVER,
    authentication: {
        type: 'default',
        options: {
            userName: process.env.DB_USER_SQL_SERVER,
            password: process.env.DB_PASSWORD_SQL_SERVER,
        },
    },
    options: {
        database: process.env.DB_NAME_SQL_SERVER,
        encrypt: false,
    },
}

var pool = new sql.ConnectionPool(config)

module.exports = { pool };
