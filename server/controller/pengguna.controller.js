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
 *  name: Pengguna
 *  description: Api untuk Pengguna
 */


/**
 * @swagger
 * /pengguna:
 *  put:
 *      summary: mengubah data pengguna
 *      tags: [Pengguna]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  password: 
 *                      type: string
 *      responses:
 *          200:
 *              description: jika data berhasil di ubah
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

 async function updatePassword(req, res) {
    var password = req.body.password
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
                            let datapengguna = {
                                password: password
                            }
                            var sqlquery = "UPDATE pengguna SET ? WHERE idpengguna = ?"
                            database.query(sqlquery, [datapengguna, jwtresult.idpengguna], (error, result) => {
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
    updatePassword
}