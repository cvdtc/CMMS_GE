require('dotenv').config()
var pool = require('../utils/pool.configuration')

var nows = {
    toSqlString: function() { return "NOW()" }
}

/**
 * @swagger
 * tags:
 *  name: Report
 *  description: Api untuk Laporan
 */


/**
 * @swagger
 * /schedule:
 *  get:
 *      summary: api untuk load data schedule ganti part mesin
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

function getSchedule(req, res) {
    pool.getConnection(function(error, database) {
        if (error) {
            return res.status(400).send({
                message: "Pool refushed, sorry :(, try again or contact developer",
                data: error
            })
        } else {
            // var sqlquery = `select m.*, c.*, datediff(date(now()), c.tanggal) as lewathari from masalah m, checkout c, bb b WHERE m.idmasalah=c.idmasalah and c.idbarang=b.BB_ID and datediff(date(now()), c.tanggal)  between b.UMUR -14 and b.UMUR+14 group by m.idmesin`
            var sqlquery = `select ms.*, datediff(date(now()), c.tanggal) as lewathari from masalah m, checkout c, bb b, mesin ms WHERE m.idmasalah=c.idmasalah and c.idbarang=b.BB_ID and m.idmesin=ms.idmesin and datediff(date(now()), c.tanggal)  between b.UMUR -14 and b.UMUR+14 group by m.idmesin`
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

/**
 * @swagger
 * /schedulepart/:idmesin:
 *  get:
 *      summary: api untuk load data schedule ganti part mesin
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

function getSchedulePart(req, res) {
    const idmesin = req.params.idmesin
    if (idmesin == "") {
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
            /// reminder schedule part di batasi 14 hari
            var sqlquery = `select b.BB_ID as kode, b.BB_NAMA as nama, b.UMUR as umur, b.BB_SATUAN as satuan, datediff(date(now()), c.tanggal) as lewathari, DATE_FORMAT( c.tgl_reminder, "%Y-%m-%d") as tgl_reminder, c.idcheckout, m.masalah from masalah m, checkout c, bb b WHERE m.idmasalah=c.idmasalah and c.idbarang=b.BB_ID and datediff(date(now()), c.tgl_reminder)  between b.UMUR -14 and b.UMUR + 14 and m.idmesin = ?`
            database.query(sqlquery, idmesin, (error, rows) => {
                database.release()
                console.log('schedule')
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
 * /timeline/:idmasalah:
 *  get:
 *      summary: api untuk load data timeline
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

function getTimeline(req, res) {
    var idmasalah = req.params.idmasalah
    if (idmasalah == "") {
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
            var sqlquery = `SELECT 1 AS tipe, m.jam, m.tanggal, m.masalah, m.shift, '-' AS perbaikan, '-' AS engginer, '-' AS tanggalprog, '-' AS shiftprog, '-' AS tanggalselesai,'-' AS keteranganselesai, '-' AS kode, '-' AS barang, '-' AS satuan, '-' AS qty, '-' AS keterangancheckout, pe.nama as penggunamasalah, '-' AS penggunaprogress, '-' AS penggunaselesai, m.jenis_masalah, '-' as tanggalbarang, '-' as kilometer FROM masalah m, pengguna pe WHERE m.idmasalah = ? and pe.idpengguna=m.idpengguna UNION SELECT 2 AS tipe, '-' AS kosong1,'-' AS kosong2,'-' AS kosong3,'-' AS kosong4, ps.perbaikan, ps.engginer, ps.tanggal, ps.shift, '-' AS kosong5, '-' AS kosong6, '-' AS kosong11, '-' AS kosong12, '-' AS kosong13, '-' AS kosong14, '-' AS kosong15, '-' as penggunamasalah, pe.nama AS penggunaprogress, '-' AS penggunaselesai, '-' as kosong16, '-' as kosong17, '-' as kosong18 FROM progress ps, pengguna pe WHERE ps.idmasalah = ? AND pe.idpengguna=ps.idpengguna UNION SELECT 3 AS tipe, '-' AS kosong1,'-' AS kosong2,'-' AS kosong3,'-' AS kosong4, '-' AS kosong5, '-' AS kosong6, '-' AS kosong7, '-' AS kosong8, p.tanggal,p.keterangan, '-' as kosong11, '-' as kosong12, '-' as kosong13, '-' as kosong14, '-' as kosong15, '-' as penggunamasalah, '-' AS penggunaprogress, pe.nama AS penggunaselesai, '-' as kosong16, '-' as kosong17, '-' as kosong18 FROM penyelesaian p, pengguna pe WHERE p.idmasalah = ? AND pe.idpengguna=p.idpengguna UNION SELECT 4 AS tipe, '-' AS kosong1,'-' AS kosong2, '-' AS kosong3, '-' AS kosong4, '-' AS kosong5, '-' AS kosong6, '-' AS kosong7, '-' AS kosong8, '-' AS kosong9, '-' AS kosong10, b.BB_ID as kode, b.BB_NAMA as nama, '-' AS nama, c.qty, c.keterangan, '-' as penggunamasalah, '-' AS penggunaprogress, '-' AS penggunaselesai, '-' as kosong11, c.tanggal as tanggalbarang, c.kilometer FROM checkout c, bb b WHERE c.idbarang=b.BB_ID and c.idmasalah = ?;`
            database.query(sqlquery, [idmasalah, idmasalah, idmasalah, idmasalah], (error, rows) => {
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
 * /stokbarang:
 *  get:
 *      summary: api untuk load data Stok barang
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

function getLaporanStok(req, res) {
    var namabarang = req.params.namabarang
    if (namabarang == "") {
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
            var sqlquery = `SELECT b.BB_ID as kode, b.BB_NAMA as nama, b.jmlt as stok, UMUR as umur, BB_SATUAN as satuan FROM (SELECT BB_ID, BB_NAMA, SUM(jml) as jmlt FROM (SELECT BB_ID, BB_NAMA, COALESCE(SUM(JUMLAH),0) AS jml, 'mrv' AS  tipe FROM mrv a, det_mrv b WHERE a.NOBUKTI=b.NOBUKTI AND BB_NAMA like '%${namabarang}%' GROUP BY BB_ID UNION SELECT BB_ID, BB_NAMA, COALESCE(SUM(-1*JUMLAH),0) AS jml, 'miv' AS  tipe FROM miv a, det_miv b WHERE a.NOBUKTI=b.NOBUKTI AND BB_NAMA like '%${namabarang}%' GROUP BY BB_ID Union SELECT BB_ID, BB_NAMA, COALESCE(SUM(JUMLAH),0) AS jml, 'asm' AS  tipe FROM asm a, det_asm b WHERE a.NOBUKTI=b.NOBUKTI AND BB_NAMA  like '%${namabarang}%' GROUP BY BB_ID Union SELECT BB_ID, BB_NAMA, COALESCE(SUM(-1*JUMLAH),0) AS jml, 'ask' AS  tipe FROM ask a, det_ask b WHERE a.NOBUKTI=b.NOBUKTI AND BB_NAMA like '%${namabarang}%' GROUP BY BB_ID)a GROUP BY BB_ID)b, bb, golx, gol WHERE b.BB_ID=bb.BB_ID AND bb.GOL=golx.G_ID AND golx.GOL=gol.KODE and gol.JENIS='SPARE PARTS'`
            database.query(sqlquery, (error, rows) => {
                console.log(sqlquery, error)
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
    getSchedule,
    getSchedulePart,
    getTimeline,
    getLaporanStok
}