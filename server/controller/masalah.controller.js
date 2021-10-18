require('dotenv').config()
var fs = require('fs')
const mysql = require('mysql')
var fcm = require('firebase-admin')
// var serviceaccount = require('../utils/cmmsgeprivatekey.json')
var serviceaccount = ''
const tonotification = 'CMMSGE_SERVICE'
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    timezone: 'utc-8'
})
// fcm.initializeApp({
//     credential: fcm.credential.cert(serviceaccount)
// })

/**
 * @swagger
 * tags:
 *  name: Masalah
 *  description: Api untuk Masalah
 */

/**
 * @swagger
 * /masalah:
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

async function getMasalah(req, res) {
    const token = req.headers.authorization.split(' ')[1];
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwterror) {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                });
            } else {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, try again or contact developer",
                            data: error
                        })
                    } else {
                        var sqlquery = "SELECT m.idmasalah, m.jam, m.tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite ORDER BY m.idmasalah DESC"
                        database.query(sqlquery, (error, rows) => {
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
            if (jwterror) {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                });
            } else {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, try again or contact developer",
                            data: error
                        })
                    } else {
                        var sqlquery = "SELECT m.*, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite WHERE m.idmesin=? ORDER BY m.idmasalah DESC"
                        database.query(sqlquery, [idmesin], (error, rows) => {
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
 *                  idmesin:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  namamesin:
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

async function addMasalah(req, res) {
    var namamesin = req.body.namamesin
    var masalah = req.body.masalah
    var tanggal = req.body.tanggal
    var jam = req.body.jam
    var idmesin = req.body.idmesin
    var shift = req.body.shift
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 6) {
        return res.status(405).send({
            message: 'parameter tidak sesuai!'
        })
    } else {
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwterror) {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                });
            } else {
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
                                            const messagenotif = {
                                                to: tonotification,
                                                notification: {
                                                    title: "Ada masalah pada mesin " + namamesin,
                                                    body: masalah
                                                }
                                            }
                                            database.release()
                                            fcm.messaging().send(messagenotif).then((response) => {
                                                console.log('Berhasil Sending Notif', response)
                                            }).catch((error) => {
                                                console.log('Gagal Sending Notif', error)
                                                fs.createWriteStream('../log/notificationlog.txt').write(Date.now() + ' : Gagal mengirim notifikasi masalah, error : ' + error)
                                            })
                                            return res.status(201).send({
                                                message: 'Data berhasil disimpan!'
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    }
                })
            }
        })
    } catch (error) {
        return res.status(403).send({
            message: 'Email atau Nomor Handphone yang anda masukkan sudah terdaftar!'
        })
    }}
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
 *                  idmesin:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  namamesin:
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
    var namamesin = req.body.namamesin
    var masalah = req.body.masalah
    var tanggal = req.body.tanggal
    var jam = req.body.jam
    var idmesin = req.body.idmesin
    var shift = req.body.shift
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 6) {
        return res.status(405).send({
            message: 'parameter tidak sesuai!'
        })
    } else {
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (jwterror) {
                return res.status(401).send({
                    message: "Sorry, Token tidak valid!",
                    data: jwterror
                });
            } else {
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
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "UPDATE masalah SET ? WHERE idmasalah = ?"
                            database.query(sqlquery, [datamasalah, idmasalah], (error, result) => {
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
                                            const messagenotif = {
                                                to: tonotification,
                                                notification: {
                                                    title: "Ada perubahan masalah pada mesin " + namamesin,
                                                    body: masalah
                                                }
                                            }
                                            database.release()
                                            fcm.messaging().send(messagenotif).then((response) => {
                                                console.log('Berhasil Sending Notif', response)
                                            }).catch((error) => {
                                                console.log('Gagal Sending Notif', error)
                                                fs.createWriteStream('../log/notificationlog.txt').write(Date.now() + ' : Gagal mengirim notifikasi ubah masalah, error : ' + error)
                                            })
                                            return res.status(201).send({
                                                message: 'Data berhasil disimpan!'
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    }
                })
            }
        })
    } catch (error) {
        return res.status(403).send({
            message: 'Email atau Nomor Handphone yang anda masukkan sudah terdaftar!'
        })
    }}
}

module.exports = {
    getMasalah,
    getMasalahByMesin,
    addMasalah,
    editMasalah
}