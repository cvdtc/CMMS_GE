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
 *  name: Site
 *  description: Api untuk load data Komponen
 */

/**
 * @swagger
 * /site:
 *  get:
 *      summary: api untuk daftar Site
 *      tags: [Site]
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

async function getSite(req, res) {
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
                        var sqlquery = "SELECT * FROM site"
                        database.query(sqlquery,(error, rows) => {
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
 * /site:
 *  post:
 *      summary: menambah data Site
 *      tags: [Site]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nama: 
 *                      type: string
 *                  keterangan:
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

 async function addSite(req, res) {
    var nama = req.body.nama
    var keterangan = req.body.keterangan
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 2) {
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
                            let datasite = {
                                nama: nama,
                                keterangan: keterangan
                            }
                            var sqlquery = "INSERT INTO site SET ?"
                            database.query(sqlquery, datasite, (error, result) => {
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
                });
            }
        })
    } catch (error) {
        return res.status(403).send({
            message: "Forbidden.",
            error: error
        })
    }}
}


/**
 * @swagger
 * /site/:idsite:
 *  put:
 *      summary: Mengubah data Site
 *      tags: [Site]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nama: 
 *                      type: string
 *                  keterangan:
 *                      type: string
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

 async function editSite(req, res) {
    var idsite = req.params.idsite
    var nama = req.body.nama
    var keterangan = req.body.keterangan
    const token = req.headers.authorization.split(' ')[1]
    if (Object.keys(req.body).length != 2) {
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
                            let datasite = {
                                nama: nama,
                                keterangan: keterangan
                            }
                            var sqlquery = "UPDATE site SET ? WHERE idsite = ?"
                            database.query(sqlquery, [datasite, idsite], (error, result) => {
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
    }}
}


/**
 * @swagger
 * /site/:idsite:
 *  delete:
 *      summary: Menghapus data Site
 *      tags: [Site]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nama: 
 *                      type: string
 *                  keterangan:
 *                      type: string
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

 async function deleteSite(req, res) {
    var idsite = req.params.idsite
    const token = req.headers.authorization.split(' ')[1]
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
                            
                            var sqlquery = "DELETE FROM site WHERE idsite = ?"
                            database.query(sqlquery, [idsite], (error, result) => {
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
    }}

module.exports = {
    getSite,
    addSite,
    editSite,
    deleteSite
}