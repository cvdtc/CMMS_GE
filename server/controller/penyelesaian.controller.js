require('dotenv').config()
var fs = require('fs')
const mysql = require('mysql')
var fcm = require('firebase-admin')
const tonotification = 'CMMSGE_SERVICE'
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
 *  name: Penyelesaian
 *  description: Api untuk Penyelesaian
 */

/**
 * @swagger
 * /penyelesaian:
 *  get:
 *      summary: api untuk load data penyelesaian
 *      tags: [Penyelesaian]
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

async function getPenyelesaian(req, res) {
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
                        var sqlquery = "SELECT * FROM penyelesaian"
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
 * /penyelesaian/:idmasalah:
 *  get:
 *      summary: api untuk load data penyelesaian berdasarkan idmasalah
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

async function getPenyelesaianByMasalah(req, res) {
    var idmasalah = req.params.idmasalah
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
                        var sqlquery = "SELECT * FROM penyelesaian WHERE idmasalah = ?"
                        database.query(sqlquery, [idmasalah], (error, rows) => {
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
 * /penyelesaian:
 *  post:
 *      summary: menambah data Penyelesaian
 *      tags: [Penyelesaian]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  tanggal: 
 *                      type: date
 *                  keterangan:
 *                      type: string
 *                  idmasalah:
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

async function addPenyelesaian(req, res) {
    var tanggal = req.body.tanggal
    var keterangan = req.body.keterangan
    var idmasalah = req.body.idmasalah
    var namamesin = req.body.namamesin
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 4) {
        return res.status(405).send({
            message: 'parameter tidak sesuai!'
        })
    } else {
        try {
            jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (jwtresult) {
                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Soory, Pool Refushed",
                                data: error
                            })
                        } else {
                            database.beginTransaction(function (error) {
                                let datapenyelesaian = {
                                    tanggal: tanggal,
                                    keterangan: keterangan,
                                    idmasalah: idmasalah
                                }
                                var sqlquery = "INSERT INTO penyelesaian SET ?"
                                database.query(sqlquery, datapenyelesaian, (error, result) => {
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
                                                        title: "Masalah pada Mesin " + namamesin + "Sudah selesai.",
                                                        body: keterangan
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
}

/**
 * @swagger
 * /penyelesaian/:idpenyelesaian:
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
 *                  tanggal: 
 *                      type: date
 *                  keterangan:
 *                      type: string
 *                  idmasalah:
 *                      type: int
 *      responses:
 *          200:
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

async function editPenyelesaian(req, res) {
    var idpenyelesaian = req.params.idpenyelesaian
    var tanggal = req.body.tanggal
    var keterangan = req.body.keterangan
    var idmasalah = req.body.idmasalah
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 3) {
        return res.status(405).send({
            message: 'parameter tidak sesuai!'
        })
    } else {
        try {
            jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (jwtresult) {

                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Soory, Pool Refushed",
                                data: error
                            })
                        } else {
                            database.beginTransaction(function (error) {
                                let datapenyelesaian = {
                                    tanggal: tanggal,
                                    keterangan: keterangan,
                                    idmasalah: idmasalah
                                }
                                var sqlquery = "UPDATE penyelesaian SET ? WHERE idpenyelesaian = ?"
                                database.query(sqlquery, [datapenyelesaian, idpenyelesaian], (error, result) => {
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
                                                database.release()
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
}

module.exports = {
    getPenyelesaian,
    getPenyelesaianByMasalah,
    addPenyelesaian,
    editPenyelesaian
}