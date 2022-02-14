require('dotenv').config()
var pool = require('../utils/pool.configuration')
var nows = {
    toSqlString: function() { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: Progress
 *  description: Api untuk Progress
 */

/**
 * @swagger
 * /progress:
 *  post:
 *      summary: menambah progress
 *      tags: [Progress]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  perbaikan: 
 *                      type: string
 *                  engineer:
 *                      type: string
 *                  tanggal:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  idmasalah:
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

async function addProgress(req, res, datatoken) {
    var perbaikan = req.body.perbaikan
    var engineer = req.body.engineer
    var tanggal = req.body.tanggal
    var idmasalah = req.body.idmasalah
    var shift = req.body.shift
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Sorry, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function(error) {
                let dataprogress = {
                    perbaikan: perbaikan,
                    engginer: engineer,
                    tanggal: tanggal,
                    idmasalah: idmasalah,
                    shift: shift,
                    created: nows,
                    idpengguna: datatoken.idpengguna
                }
                var sqlquery = "INSERT INTO progress SET ?"
                database.query(sqlquery, dataprogress, (error, result) => {
                    database.release()
                    console.log(result)
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
                                    message: "Done!,  Data has been stored!2",
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
 * /progress/:idprogress:
 *  put:
 *      summary: mengubah data progress
 *      tags: [Progress]
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

async function editProgress(req, res, datatoken) {
    var idprogress = req.params.idprogress
    var perbaikan = req.body.perbaikan
    var engineer = req.body.engineer
    var tanggal = req.body.tanggal
    var idmasalah = req.body.idmasalah
    var shift = req.body.shift
    console.log(' edit Progress...')
    if (idprogress == "") {
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
                let dataprogress = {
                    perbaikan: perbaikan,
                    engginer: engineer,
                    tanggal: tanggal,
                    idmasalah: idmasalah,
                    shift: shift,
                    edited: nows,
                    idpengguna: datatoken.idpengguna
                }
                var sqlquery = "UPDATE progress SET ? WHERE idprogress = ?"
                database.query(sqlquery, [dataprogress, idprogress], (error, result) => {
                    database.release()
                    console.log(result);
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
}

module.exports = {
    addProgress,
    editProgress
}