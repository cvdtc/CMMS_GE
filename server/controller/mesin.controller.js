require('dotenv').config()
var pool = require('../utils/pool.configuration')

/**
 * @swagger
 * tags:
 *  name: Mesin
 *  description: Api untuk Mesin
 */

/**
 * @swagger
 * /mesin/:idsite:
 *  get:
 *      summary: api untuk load data mesin berdasarkan idsite, tapi jika idsite 0 maka akan keluar semua data mesin
 *      tags: [Mesin]
 *      parameters:
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  idsite: 
 *                      type: integer
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

function getMesin(req, res) {
    var idsite = req.params.idsite
    var filterquery = ""
    if (idsite == "") {
        return res.status(400).send({
            message: "Parameter doesn't match!",
            data: null
        })
    }
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            // * if idsite == 0 run all query without where idsite
            if (idsite != 0) filterquery = ' AND idsite = ?'
                ///////////////////////////////////////////////
            var sqlquery = "SELECT m.*, s.nama as site FROM mesin m, site s WHERE m.idsite=s.idsite " + filterquery + " ORDER BY m.idsite, m.nomesin ASC"
            database.query(sqlquery, [idsite], (error, rows) => {
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
    var nomesin = req.body.nomesin
    var keterangan = req.body.keterangan
    var idsite = req.body.idsite
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Soory, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function(error) {
                let datamesin = {
                    nomesin: nomesin,
                    keterangan: keterangan,
                    idsite: idsite
                }
                var sqlquery = "INSERT INTO mesin SET ?"
                database.query(sqlquery, datamesin, (error, result) => {
                    database.release()
                    if (error) {
                        database.rollback(function() {

                            return res.status(407).send({
                                message: 'Sorry :(, we have problems sql query!',
                                error: error
                            })
                        })
                    } else {
                        database.commit(function(errcommit) {
                            if (errcommit) {
                                database.rollback(function() {
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
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nomesin: 
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  idsite:
 *                      type: int
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
    var idmesin = req.params.idmesin
    var nomesin = req.body.nomesin
    var keterangan = req.body.keterangan
    var idsite = req.body.idsite
    if (idmesin == "") {
        return res.status(400).send({
            message: "Parameter doesn't match!",
            data: null
        })
    }
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Soory, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function(error) {
                let datamesin = {
                    nomesin: nomesin,
                    keterangan: keterangan,
                    idsite: idsite
                }
                var sqlquery = "UPDATE mesin SET ? WHERE idmesin = ?"
                database.query(sqlquery, [datamesin, idmesin], (error, result) => {
                    database.release()
                    if (error) {
                        database.rollback(function() {
                            return res.status(407).send({
                                message: 'Sorry :(, we have problems sql query!',
                                error: error
                            })
                        })
                    } else {
                        database.commit(function(errcommit) {
                            if (errcommit) {
                                database.rollback(function() {
                                    return res.status(407).send({
                                        message: 'data gagal diperbarui!'
                                    })
                                })
                            } else {
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
}


module.exports = {
    getMesin,
    addMesin,
    editMesin
}