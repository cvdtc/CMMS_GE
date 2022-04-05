require('dotenv').config()
var { pool } = require('../utils/poolsqlserver.configuration')

/**
 * @swagger
 * tags:
 *  name: ReportPlat3
 *  description: Api untuk Laporan web plant 3
 */


/**
 * @swagger
 * /chartdataproduksi3:
 *  get:
 *      summary: api untuk load data chart produksi plant 3
 *      tags: [ReportPlat3]
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



async function getChartDataProduksiPlant3(req, res) {
    var periode = req.params.periode
    /// using pool configuration
    pool.connect().then(pools => {
        /// execution query
        return pools.request().query("select Cast(Casting_Date as varchar) as tanggal, AVG(S_Slurry) as ss, AVG(W_Slurry) as ws, AVG(Cement) as c, AVG(Lime) as l from GEmixingp3 where CEMENT>100 and Casting_Date>=DATEADD(day,-14, GETDATE()) GROUP BY Casting_Date")
    }).then(response => {
        /// return data when success execute
        return res.status(200).send({
            message: `Data ${periode} berhasil fetch.`,
            data: response.recordsets
        })
    }).catch(error => {
        /// return error result when error
        return res.status(500).send({
            message: "Masalah internal server",
            data: error
        })
    }).finally(() => {
        /// close pool connection to reduce queue query
        console.log('Data Analisa Produksi Done!')
        pool.close()
    })
}


module.exports={
    getChartDataProduksiPlant3
}