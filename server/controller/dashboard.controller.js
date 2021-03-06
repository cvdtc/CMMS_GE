require('dotenv').config()
var pool = require('../utils/pool.configuration')

/**
 * @swagger
 * tags:
 *  name: Dashboard
 *  description: Api untuk load statistik dashboard
 */

/**
 * @swagger
 * /dashboard:
 *  get:
 *      summary: api untuk dashboard statistik jumlah masalah dan masalah selesai
 *      tags: [Dashboard]
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

async function getDashboard(req, res) {
    var pool = require('../utils/pool.configuration')
    pool.getConnection(function (error, database) {
        if (error) {
            console.log('masuk dashboard tier 1')
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = "SELECT count(m.idmasalah) as jml_masalah, COUNT(p.idpenyelesaian) as jml_selesai FROM masalah m LEFT JOIN penyelesaian p on m.idmasalah=p.idmasalah"
            database.query(sqlquery, (error, rows) => {
                database.release()
                if (error) {
                    console.log('masuk dashboard tier 2')
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
//	                database.release()
                        console.log('masuk dashboard tier 3')
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
 * /dashboardinputsummary:
 *  get:
 *      summary: api untuk  statistik jumlah masalah ter input setiap hari
 *      tags: [Dashboard]
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

 function getSummaryInput(req, res) {
    var pool = require('../utils/pool.configuration')
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            var sqlquery = `select count(idmasalah) jumlah_activity, date_format(created, "%Y-%m-%d") as tanggal from masalah where date(created) > date_sub(curdate(), interval 14 day) group by date(created)`
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

module.exports = {
    getDashboard,
    getSummaryInput
}
