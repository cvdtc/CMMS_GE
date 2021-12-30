require('dotenv').config()
const jwt = require('jsonwebtoken')
var fs = require('fs')
const mysql = require('mysql')
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    timezone: 'utc-8',
    waitForConnections: true,
    connectTimeout: 36000
})

var nows = {
    toSqlString: function () { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: Barang
 *  description: Api untuk Barang
 */

/**
 * @swagger
 * /barang:
 *  get:
 *      summary: api untuk load data barang/bb
 *      tags: [Barang]
 *      responses:
 *          200:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          500:
 *              description: kesalahan pada query sql
 */

function getBarang(req, res) {
    const token = req.headers.authorization
    console.log('Load Barang...')
    try {
        jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwtresult) {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, please try again or contact developer.",
                            data: error
                        })
                    } else {
                        var sqlquery = `SELECT b.BB_ID as idbarang, b.BB_NAMA as nama, b.umur as umur_pakai, '-' as keterangan, '1' as idsatuan, b.BB_SATUAN as satuan FROM bb b, golx, gol WHERE b.gol=golx.G_ID and golx.GOL=gol.kode and gol.JENIS='SPARE PARTS'`
                        database.query(sqlquery, (error, rows) => {
                            database.release()
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry :(, my query has been error",
                                    data: error
                                })
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
                                        message: "Data masih kosong",
                                        data: rows
                                    })
                                } else {
                                    return res.status(200).send({
                                        message: "Data berhasil fetch.",
                                        data: rows
                                    })
                                }
                            }
                        })
                    }
                })
            } else {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                });
            }
        })
    } catch (error) {
        console.log(error)
        return res.status(403).send({
            message: "Forbidden.",
            error: error
        })
    }
}

module.exports = {
    getBarang
}