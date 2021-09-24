require('dotenv').config()
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
 *  name: Mesin
 *  description: Api untuk Mesin
 */

/**
 * @swagger
 * /mesin:
 *  get:
 *      summary: api untuk load data mesin
 *      tags: [Mesin]
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

async function getMesin(req, res) {
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                return res.status(400).send({
                    message: "Pool refushed, sorry :(, try again or contact developer",
                    data: error
                })
            } else {
                var sqlquery = "SELECT a.*, b.nama as site FROM mesin a, site b where a.idsite=b.idsite"
                database.query(sqlquery, (error, rows) => {
                    if (error) {
                        return res.status(500).send({
                            message: "Sorry :(, my query has been error",
                            data: error
                        });
                    } else {
                        if (rows.length <= 0) {
                            return res.status(204).send({
                                message: "Data masih kosong",
                                data: rows
                            });
                        } else {
                            return res.status(200).send({
                                message: "Data berhasil fetch.",
                                data: rows
                            });
                        }
                    }
                })
            }
        })
    } catch (error) {
        return res.status(403).send({
            message: "Forbidden.",
            error: error
        });
    }
}


/**
 * @swagger
 * /mesin:
 *  post:
 *      summary: menambah data Mesin
 *      tags: [Mesin]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nomesin: 
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  idsite:
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

 async function addMesin(req, res) {
    var nomesin = req.body.nomesin;
    var keterangan = req.body.keterangan;
    var idsite = req.body.idsite;
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                return res.status(400).send({
                    message: "Soory, Pool Refushed",
                    data: error
                });
            } else {
                database.beginTransaction(function (error) {
                    let datamesin = {
                        nomesin: nomesin,
                        keterangan: keterangan,
                        idsite: idsite
                    }
                    var sqlquery = "INSERT INTO mesin SET ?"
                    database.query(sqlquery, datamesin, (error, result) => {
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

    } catch (error) {
        return res.status(403).send({
            message: 'Email atau Nomor Handphone yang anda masukkan sudah terdaftar!'
        })
    }
}

/**
 * @swagger
 * /mesin/:idmesin:
 *  put:
 *      summary: Mengubah data Mesin
 *      tags: [Mesin]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nomesin: 
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  idsite:
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

async function editMesin(req, res) {
    var idmesin = req.params.idmesin;
    var nomesin = req.body.nomesin;
    var keterangan = req.body.keterangan;
    var idsite = req.body.idsite;
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                return res.status(400).send({
                    message: "Soory, Pool Refushed",
                    data: error
                });
            } else {
                database.beginTransaction(function (error) {
                    let datamesin = {
                        nomesin: nomesin,
                        keterangan: keterangan,
                        idsite: idsite
                    }
                    var sqlquery = "UPDATE mesin SET ? WHERE idmesin = ?"
                    database.query(sqlquery, [datamesin, idmesin], (error, result) => {
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
                                            message: 'data gagal diperbarui!'
                                        })
                                    })
                                } else {
                                    database.release()
                                    return res.status(200).send({
                                        message: 'Data berhasil diperbarui!'
                                    })
                                }
                            })
                        }
                    })
                })
            }
        })

    } catch (error) {
        return res.status(403).send({
            message: 'Email atau Nomor Handphone yang anda masukkan sudah terdaftar!'
        })
    }
}


module.exports = {
    getMesin,
    addMesin,
    editMesin
}