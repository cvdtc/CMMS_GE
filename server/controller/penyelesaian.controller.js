require('dotenv').config()
var pool = require('../utils/pool.configuration')
var nows = {
    toSqlString: function () { return "NOW()" }
}

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

    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = "SELECT * FROM penyelesaian"
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
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = "SELECT * FROM penyelesaian WHERE idmasalah = ?"
            database.query(sqlquery, [idmasalah], (error, rows) => {
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

async function addPenyelesaian(req, res, datatoken) {
    var tanggal = req.body.tanggal
    var keterangan = req.body.keterangan
    var idmasalah = req.body.idmasalah
    console.log(datatoken, datatoken.idpengguna)
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Sorry, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function (error) {
                let datapenyelesaian = {
                    tanggal: tanggal,
                    keterangan: keterangan,
                    idmasalah: idmasalah,
                    created: nows,
                    idpengguna: datatoken.idpengguna
                }
                var sqlquery = "INSERT INTO penyelesaian SET ?"
                database.query(sqlquery, datapenyelesaian, (error, result) => {
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
                                var sqlquery = 'UPDATE masalah SET flag_activity = 1 WHERE idmasalah = ?'
                                database.query(sqlquery, idmasalah, (error, resultupdatemasalah) => {
                                    return res.status(201).send({
                                        message: "Done!,  Data has been stored!",
                                    })
                                });
                            }
                        })
                    }
                })
            })
        }
    })
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

async function editPenyelesaian(req, res, datatoken) {
    var idpenyelesaian = req.params.idpenyelesaian
    var tanggal = req.body.tanggal
    var keterangan = req.body.keterangan
    var idmasalah = req.body.idmasalah
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
                    idmasalah: idmasalah,
                    idpengguna: datatoken.idpengguna
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
}

/**
 * @swagger
 * /penyelesaian/:idpenyelesaian:
 *  delete:
 *      summary: Menghapus data Penyelesaian
 *      tags: [Penyelesaian]
 *      consumes:
 *          - application/json
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

async function deletePenyelesaian(req, res) {
    var idpenyelesaian = req.params.idpenyelesaian
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Soory, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function (error) {
                var sqlquery = "DELETE FROM penyelesaian WHERE idpenyelesaian = ?"
                database.query(sqlquery, [idpenyelesaian], (error, result) => {
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
                                        message: 'data gagal menghapus!'
                                    })
                                })
                            } else {
                                database.release()
                                return res.status(200).send({
                                    message: 'Data berhasil dihapus!'
                                })
                            }
                        })
                    }
                })
            })
        }
    })
}

module.exports = {
    getPenyelesaian,
    getPenyelesaianByMasalah,
    addPenyelesaian,
    editPenyelesaian,
    deletePenyelesaian
}