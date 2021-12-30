
require('dotenv').config()
const jwt = require('jsonwebtoken')
const mysql = require('mysql')
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    timezone: 'utc-8'
})

var nows = {
    toSqlString: function () { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: Report
 *  description: Api untuk Laporan
 */

/**
 * @swagger
 * /timeline/:idmasalah:
 *  get:
 *      summary: api untuk load data timeline
 *      tags: [Report]
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



 function getTimeline(req, res) {
    const token = req.headers.authorization.split(' ')[1]
    var idmasalah = req.params.idmasalah
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwtresult) {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, try again or contact developer",
                            data: error
                        })
                    } else {
                        var sqlquery = `SELECT 1 AS tipe, m.jam, m.tanggal, m.masalah, m.shift, '-' AS perbaikan, '-' AS engginer, '-' AS tanggalprog, '-' AS shiftprog, '-' AS tanggalselesai,'-' AS keteranganselesai, '-' AS kode, '-' AS barang, '-' AS satuan, '-' AS qty, '-' AS keterangancheckout FROM masalah m WHERE m.idmasalah=? UNION SELECT 2 AS tipe, '-' AS kosong1,'-' AS kosong2,'-' AS kosong3,'-' AS kosong4, ps.perbaikan, ps.engginer, ps.tanggal, ps.shift, '-' AS kosong5, '-' AS kosong6, '-' AS kosong11, '-' AS kosong12, '-' AS kosong13, '-' AS kosong14, '-' AS kosong15 FROM progress ps WHERE ps.idmasalah=?  UNION SELECT 3 AS tipe, '-' AS kosong1,'-' AS kosong2,'-' AS kosong3,'-' AS kosong4, '-' AS kosong5, '-' AS kosong6, '-' AS kosong7, '-' AS kosong8, p.tanggal, p.keterangan, '-' as kosong11, '-' as kosong12, '-' as kosong13, '-' as kosong14, '-' as kosong15 FROM penyelesaian p WHERE p.idmasalah=? UNION SELECT 4 AS tipe, '-' AS kosong1,'-' AS kosong2, '-' AS kosong3, '-' AS kosong4, '-' AS kosong5, '-' AS kosong6, '-' AS kosong7, '-' AS kosong8, '-' AS kosong9, '-' AS kosong10, b.BB_ID as kode, b.BB_NAMA as nama, '-' AS nama, c.qty, c.keterangan FROM checkout c, bb b WHERE c.idbarang=b.BB_ID and c.idmasalah=?`
                        database.query(sqlquery, [idmasalah, idmasalah, idmasalah, idmasalah], (error, rows) => {
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
    getTimeline
}