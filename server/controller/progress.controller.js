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

async function addProgress(req, res) {
    var perbaikan = req.body.perbaikan
    var engineer = req.body.engineer
    var tanggal = req.body.tanggal
    var idmasalah = req.body.idmasalah
    var shift = req.body.shift
    const token = req.headers.authorization
    console.log('Mencoba insert progress...')
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
                            let dataprogress = {
                                perbaikan: perbaikan,
                                engginer: engineer,
                                tanggal: tanggal,
                                idmasalah: idmasalah,
                                shift: shift,
                                created: nows,
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "INSERT INTO progress SET ?"
                            database.query(sqlquery, dataprogress, (error, result) => {
                                database.release()
                                console.log(result)
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
                                                message: "Done!,  Data has been stored!2",
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
 * /progress/:progress:
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

async function editProgress(req, res) {
    var idprogress = req.params.idprogress
    var perbaikan = req.body.perbaikan
    var engineer = req.body.engineer
    var tanggal = req.body.tanggal
    var idmasalah = req.body.idmasalah
    var shift = req.body.shift
    const token = req.headers.authorization
    try {
        jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
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
                            let dataprogress = {
                                perbaikan: perbaikan,
                                engginer: engineer,
                                tanggal: tanggal,
                                idmasalah: idmasalah,
                                shift: shift,
                                edited: nows,
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "UPDATE progress SET ? WHERE idprogress = ?"
                            database.query(sqlquery, [dataprogress, idprogress], (error, result) => {
                                database.release()
                                console.log(result);
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
    addProgress, editProgress
}