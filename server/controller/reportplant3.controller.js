require('dotenv').config()
const sqlserver = require('mssql')
var { sqlConfig, poolserver } = require('../utils/poolsqlserver.configuration')

/**
 * @swagger
 * tags:
 *  name: ReportPlat3
 *  description: Api untuk Laporan web plant 3
 */


/**
 * @swagger
 * /schedule:
 *  get:
 *      summary: api untuk load data schedule ganti part mesin
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


async function getDataProduksiPlant3(req, res) {
    sqlserver.connect(sqlConfig).then(pool => {
        pool.request().query(`select TOP 2000 GEmixingp3.Datetime, Cast(GEmixingp3.Casting_Date as varchar) as periode, GEmixingp3.No_Produksi, GEmixingp3.No_Mould, S_Slurry, SS_Target, GEmixingp3.SS_Density, W_Slurry, WS_Target, GEmixingp3.WS_Density, Water, Cement, Cement_Target, Lime, Lime_Target, GEmixingp3.Alumunium, GEmixingp3.Temperature, GEmixingp3.ID, Formula_Code as FC, c.No_autoclave as autoc_no, c.Autoclave_In as autoc_in, c.Autoclave_Out as autoc_out, End_Height as endh from GEmixingp3, Masterdatarecipe b, GEmainprosesp3 c where GEmixingp3.ID_Recipe=b.ID and Gemixingp3.No_Produksi=c.No_Produksi ORDER BY GEmixingp3.Datetime desc`)
    }).then(result => {
        console.log(result)
        sqlserver.close()
        return req.status(200).send({
            message: "Data berhasil fetch.",
            data: result
        })

    }).catch(error => {
        console.log(error.message)
        sqlserver.close()
    })
}

module.exports = {
    getDataProduksiPlant3
}