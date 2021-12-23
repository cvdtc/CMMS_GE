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



function getMasalah(req, res) {
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
                        var sqlquery = `SELECT m.idmasalah, m.jam, DATE_FORMAT( m.tanggal, "%Y-%m-%d") as tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite WHERE month(m.tanggal)=month(now())-1 ORDER BY m.tanggal DESC`
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
                if (jwtresult) {

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
                                                var getmesin = "SELECT nomesin, keterangan FROM mesin WHERE idmesin = ?"
                                                database.query(getmesin, idmesin, (error, result) => {
                                                    database.release()
                                                    // * set firebase notification message 
                                                    let notificationMessage = {
                                                        notification: {
                                                            title: `Ada Masalahn baru pada Mesin ${result[0].keterangan} ( ${result[0].nomesin} )`,
                                                            body: masalah,
                                                            sound: 'default',
                                                            'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                        },
                                                        data: {
                                                            "judul": `Ada Masalahn baru pada Mesin ${result[0].keterangan} ( ${result[0].nomesin} )`,
                                                            "isi": masalah
                                                        }
                                                    }
                                                    // * sending notification topic RMSPERMINTAAN
                                                    fcmadmin.messaging().sendToTopic('CMMSMASALAH', notificationMessage)
                                                        .then(function (response) {
                                                            return res.status(201).send({
                                                                message: "Done!,  Data has been stored!",
                                                            })
                                                        }).catch(function (error) {
                                                            return res.status(201).send({
                                                                message: "Done!,  Data has been stored!",
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
                if (jwtresult) {

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
 * /timeline/:idmasalah:
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
    getMasalah,
    getMasalahByMesin,
    addMasalah,
    editMasalah,
    getTimeline
}