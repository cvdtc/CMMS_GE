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

/**
 * @swagger
 * tags:
 *  name: Komponen
 *  description: Api untuk load data Komponen
 */

/**
 * @swagger
 * /komponen/:idmesin:
 *  get:
 *      summary: api untuk daftar komponen
 *      tags: [Komponen]
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

async function getKomponen(req, res) {
    const token = req.headers.authorization.split(' ')[1]
    var idmesin = req.params.idmesin;
    var filterquery = ""
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
                        // * if idsite == 0 run all query without where idsite
                        if(idmesin != 0) filterquery = 'WHERE idmesin = ?'
                        ///////////////////////////////////////////////
                        var sqlquery = "SELECT k.*, m.nomesin, m.keterangan as mesin, s.nama as site FROM komponen k, mesin m, site s WHERE k.idmesin=m.idmesin AND m.idsite=s.idsite "+filterquery
                        database.query(sqlquery, idmesin,(error, rows) => {
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
        return res.status(403).send({
            message: "Forbidden.",
            error: error
        })
    }
}

/**
 * @swagger
 * /timeline/:idmasalah:
 *  get:
 *      summary: api untuk daftar komponen
 *      tags: [Komponen]
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

async function getTimeLine(req, res) {
    const token = req.headers.authorization.split(' ')[1]
    var idmasalah = req.params.idmasalah;
    var filterquery = ""
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
                        var sqlquery = `SELECT msn.idmesin, msn.nomesin, k.idkomponen, k.nama AS komponen  FROM mesin msn, masalah m, bb b, checkout c, penyelesaian p, komponen k WHERE msn.idmesin=k.idmesin AND msn.idmesin=m.idmesin AND m.idmasalah=c.idmasalah and c.idbarang=b.BB_ID and p.idmasalah=m.idmasalah and date_add(p.tanggal, interval b.umur-7 day) BETWEEN date(now()) AND date_add(now(), interval 7 day);`
                        database.query(sqlquery, idmesin,(error, rows) => {
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
        return res.status(403).send({
            message: "Forbidden.",
            error: error
        })
    }
}

module.exports = {
    getKomponen
}