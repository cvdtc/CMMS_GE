require('dotenv').config()
const jwt = require('jsonwebtoken')
var fs = require('fs')
const mysql = require('mysql')
const fcmadmin = require('../utils/firebase.configuration')
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
 *  name: Masalah
 *  description: Api untuk Masalah
 */

/**
 * @swagger
 * /masalah/:flag_activity:
 *  get:
 *      summary: api untuk load data masalah
 *      tags: [Masalah]
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

function getMasalah(req, res) {
    const token = req.headers.authorization.split(' ')[1]
    var flag_activity = req.params.flag_activity
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwtresult) {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, please try again or contact developer.",
                            data: error
                        })
                    } else {
                        var sqlquery = `SELECT m.idmasalah, m.jam, DATE_FORMAT( m.tanggal, "%Y-%m-%d") as tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status, DATE_FORMAT( m.created, "%Y-%m-%d %H:%i") as created, m.jenis_masalah, m.flag_activity FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite WHERE m.flag_activity=? ORDER BY m.tanggal DESC;`
                        database.query(sqlquery, flag_activity, (error, rows) => {
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

/**
 * @swagger
 * /masalah/:idmesin:
 *  get:
 *      summary: api untuk load data masalah
 *      tags: [Masalah]
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

async function getMasalahByMesin(req, res) {
    var idmesin = req.params.idmesin
    const token = req.headers.authorization.split(' ')[1]
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
                        var sqlquery = "SELECT m.*, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite WHERE m.idmesin=? ORDER BY m.idmasalah DESC"
                        database.query(sqlquery, [idmesin], (error, rows) => {
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
                })
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
 * /masalah:
 *  post:
 *      summary: menambah data Masalah
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  masalah: 
 *                      type: string
 *                  tanggal:
 *                      type: string
 *                  jam:
 *                      type: string
 *                  idmesin:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  jenis_masalah:
 *                      type: string
 *                  flag_activity:
 *                      type: int
 *      responses:
 *          201:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password 
 *          500:
 *              description: kesalahan pada query sql
 */

async function addMasalah(req, res) {
    var masalah = req.body.masalah
    var tanggal = req.body.tanggal
    var jam = req.body.jam
    var idmesin = req.body.idmesin
    var shift = req.body.shift
    var jenis_masalah = req.body.jenis_masalah
    var flag_activity = req.body.flag_activity
    const token = req.headers.authorization
    console.log('Mencoba insert...')
    try {
        jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwtresult) {

                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Sorry, Pool Refushed",
                            data: error
                        })
                    } else {
                        database.beginTransaction(function (error) {
                            let datamasalah = {
                                masalah: masalah,
                                tanggal: tanggal,
                                jam: jam,
                                idmesin: idmesin,
                                shift: shift,
                                jenis_masalah: jenis_masalah,
                                flag_activity: flag_activity,
                                created: nows,
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "INSERT INTO masalah SET ?"
                            database.query(sqlquery, datamasalah, (error, result) => {
                                if (error) {
                                    database.rollback(function () {
                                        database.release()
                                        return res.status(407).send({
                                            message: 'Sorry :(, we have problems sql query!',
                                            error: error
                                        })
                                    })
                                } else {
                                    database.commit(function (errcommit) {
                                        if (errcommit) {
                                            database.rollback(function () {
                                                database.release()
                                                return res.status(407).send({
                                                    message: 'data gagal disimpan!'
                                                })
                                            })
                                        } else {
                                            var getmesin = "SELECT nomesin, keterangan FROM mesin WHERE idmesin = ?"
                                            database.query(getmesin, idmesin, (error, result) => {
                                                database.release()
                                                // * set firebase notification message 
                                                let notificationMessage = {
                                                    notification: {
                                                        title: `Ada Masalah pada ${result[0].keterangan} ( ${result[0].nomesin} )`,
                                                        body: masalah,
                                                        sound: 'default',
                                                        'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                    },
                                                    data: {
                                                        "judul": `Ada Masalah pada ${result[0].keterangan} ( ${result[0].nomesin} )`,
                                                        "isi": masalah
                                                    }
                                                }
                                                // * sending notification topic RMSPERMINTAAN
                                                fcmadmin.messaging().sendToTopic('CMMSMASALAH', notificationMessage)
                                                    .then(function (response) {
                                                        return res.status(201).send({
                                                            message: "Done!,  Data has been stored!2",

                                                        })
                                                    }).catch(function (error) {
                                                        return res.status(201).send({
                                                            message: "Done!,  Data has been stored!, but notification can't send to topic.",
                                                        })
                                                    })
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    }
                })
            } else {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                })
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
 * /masalah/:idmasalah:
 *  put:
 *      summary: mengubah data Masalah
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  masalah: 
 *                      type: string
 *                  tanggal:
 *                      type: string
 *                  jam:
 *                      type: string
 *                  idmesin:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  jenis_masalah:
 *                      type: string
 *      responses:
 *          201:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password 
 *          500:
 *              description: kesalahan pada query sql
 */

async function editMasalah(req, res) {
    var idmasalah = req.params.idmasalah
    var masalah = req.body.masalah
    var tanggal = req.body.tanggal
    var jam = req.body.jam
    var idmesin = req.body.idmesin
    var shift = req.body.shift
    var flag_activity = req.body.flag_activity
    var jenis_masalah = req.body.jenis_masalah
    const token = req.headers.authorization.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwtresult) {
                console.log('Mencoba edit...')
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Soory, Pool Refushed",
                            data: error
                        })
                    } else {
                        database.beginTransaction(function (error) {
                            let datamasalah = {
                                masalah: masalah,
                                tanggal: tanggal,
                                jam: jam,
                                idmesin: idmesin,
                                shift: shift,
                                jenis_masalah: jenis_masalah,
                                flag_activity: flag_activity,
                                edited: nows,
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "UPDATE masalah SET ? WHERE idmasalah = ?"
                            database.query(sqlquery, [datamasalah, idmasalah], (error, result) => {
                                database.release()
                                if (error) {
                                    database.rollback(function () {
                                        return res.status(407).send({
                                            message: 'Sorry :(, we have problems sql query!',
                                            error: error
                                        })
                                    })
                                } else {
                                    database.commit(function (errcommit) {
                                        if (errcommit) {
                                            database.rollback(function () {
                                                return res.status(407).send({
                                                    message: 'data gagal disimpan!'
                                                })
                                            })
                                        } else {
                                            return res.status(200).send({
                                                message: 'Data berhasil disimpan!'
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    }
                })
            } else {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                })
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
    getMasalah,
    getMasalahByMesin,
    addMasalah,
    editMasalah
}