const sqlserver = require('mssql')

const sqlConfig= {
    user : process.env.DB_USER_SQL_SERVER,
    password : process.env.DB_PASSWORD_SQL_SERVER,
    server : process.env.DB_HOST_SQL_SERVER,
    database : process.env.DB_NAME_SQL_SERVER,
    pool:{
        max: 25,
        min: 0,
    },
    options:{
        trustServerCertificate: true
    }
}

const poolserver = new sqlserver.ConnectionPool(sqlConfig)

module.exports = {poolserver, sqlConfig};
