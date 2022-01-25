require('dotenv').config()
var connection = require('../utils/pool.configuration')

var nows = {
    toSqlString: function () { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: Barang
 *  description: Api untuk Barang
 */

/**
 * @swagger
 * /barang:
 *  get:
 *      summary: api untuk load data barang/bb
 *      tags: [Barang]
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



function getBarang(req, res) {
    console.log('geting barang...')
    connection.getConnection(function (error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, please try again or contact developer.",
                data: error
            })
        } else {
            var sqlquery = `SELECT b.BB_ID as idbarang, b.BB_NAMA as nama, b.umur as umur_barang, b.BB_SATUAN as satuan FROM bb b, golx, gol WHERE b.gol=golx.G_ID and golx.GOL=gol.kode and gol.JENIS='SPARE PARTS'`
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
    getBarang
}