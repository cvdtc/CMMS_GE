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

async function getMasalah(req, res) {
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                return res.status(400).send({
                    message: "Pool refushed, sorry :(, try again or contact developer",
                    data: error
                })
            } else {
                var sqlquery = "SELECT m.idmasalah, m.jam, m.tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite ORDER BY m.idmasalah DESC;"
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
     var idmesin = req.params.idmesin;
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                return res.status(400).send({
                    message: "Pool refushed, sorry :(, try again or contact developer",
                    data: error
                })
            } else {
                var sqlquery = "SELECT m.*, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as status FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite WHERE m.idmesin=? ORDER BY m.idmasalah DESC"
                database.query(sqlquery, [idmesin], (error, rows) => {
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

module.exports = {
    getMesin,
    addMesin,
    editMesin
}