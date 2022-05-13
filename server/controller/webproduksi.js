require('dotenv').config()
var pool = require('../utils/pool.configuration')

var nows = {
    toSqlString: function () { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: WebProduksi
 *  description: Api yang dibuat untuk web produksi
 */


/**
 * @swagger
 * /ringkasanmesin:
 *  get:
 *      summary: api untuk load data ringkasan mesin
 *      tags: [Report]
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

function RingkasanMesin(req, res) {
    const { idmesin } = req.params
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = `select b.keterangan as namamesin, c.nama as lokasi, COUNT(*) as jml, MAX(TANGGAL) as lastdate, DATEDIFF(NOW(), MAX(TANGGAL)) as lastcheck, (select COUNT(*) from masalah m where not exists (select idmasalah from penyelesaian p where m.idmasalah=p.idmasalah) and m.idmesin = ?) as stat from masalah a, mesin b, site c where a.idmesin=b.idmesin and b.idsite=c.idsite and a.idmesin = ?`
            database.query(sqlquery, [idmesin, idmesin], (error, rows) => {
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
 * /ringkasanmesin:
 *  get:
 *      summary: api untuk load data ringkasan mesin
 *      tags: [Report]
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

 function ChartMesin(req, res) {
    const { idmesin } = req.params
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = `Select DATE_FORMAT(tanggal, '%m-%Y') as periode, count(*) as total from masalah where idmesin = ? and DATE(tanggal) between last_day(now())+interval 1 day - interval 6 month and now() GROUP BY DATE_FORMAT(tanggal, '%m-%Y')`
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
}

/**
 * @swagger
 * /datagantipart:
 *  get:
 *      summary: api untuk load data ringkasan mesin
 *      tags: [Report]
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

 function DataGantiPart(req, res) {
    const { idmesin } = req.params
    pool.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = `select idbarang as KODE, BB_NAMA as NAMA, checkout.tanggal, bb.UMUR, qty, keterangan from checkout, masalah, bb where checkout.idmasalah=masalah.idmasalah and checkout.idbarang=bb.BB_ID and masalah.idmesin=?`
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
}

module.exports = {
    RingkasanMesin,
    ChartMesin, 
    DataGantiPart
}