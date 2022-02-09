require('dotenv').config()
var pool = require('../utils/pool.configuration')
var nows = {
    toSqlString: function() { return "NOW()" }
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
 *                  username: 
 *                      type: string
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

async function updateProfile(req, res, datatoken) {
    var username = req.body.username
    var password = req.body.password
    console.log('Mencoba edit...')
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Sorry, Pool Refushed",
                data: error
            })
        } else {
            database.beginTransaction(function(error) {
                let datapengguna = {
                    username: username,
                    password: password
                }
                var sqlquery = "UPDATE pengguna SET ? WHERE idpengguna = ?"
                database.query(sqlquery, [datapengguna, datatoken.idpengguna], (error, result) => {
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
    updateProfile
}