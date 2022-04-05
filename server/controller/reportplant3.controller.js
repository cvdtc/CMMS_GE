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
 * /analisaproduksi3:
 *  get:
 *      summary: api untuk load data analisa produksi plant 3
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



async function getDataAnalisaProduksiPlant3(req, res) {
    var periode = req.params.periode
    /// using pool configuration
    pool.connect().then(pools => {
        /// execution query
        /// filtering query with period
        if (periode == 'all') {
            return pools.request().query("select TOP 2000 Datetime, No_Produksi, No_Mould, S_Slurry, SS_Density, W_Slurry, WS_Density, Water, Cement, Lime, Alumunium, Temperature, ID from GEmixingp3 ORDER BY Datetime desc")
        } else if (periode == 'daily') {
            return pools.request().query("select periode, CAST(MIN(No_Produksi) as varchar)+' - '+CAST(MAX(No_Produksi) as varchar) as No_Produksi, COUNT(No_Mould) as No_Mould, Cast(ROUND(AVG(S_Slurry),2) as Numeric(10,2)) as S_Slurry, Cast(ROUND(AVG(SS_Density),2) as Numeric(10,2)) as SS_Density, Cast(ROUND(AVG(W_Slurry),2) as Numeric(10,2)) as W_Slurry, Cast(Round(AVG(WS_Density),2) as Numeric(10,2)) as WS_Density, Cast(Round(AVG(Water),2) as Numeric(10,2)) as Water, Cast(ROUND(AVG(Cement),2) as Numeric(10,2)) as Cement, Cast(Round(AVG(Lime),2) as Numeric(10,2)) as Lime, Cast(Round(AVG(Alumunium),2) as Numeric(10,2)) as Alumunium, Cast(Round(AVG(Temperature),2) as Numeric(10,2)) as Temperature, '-' as ID from (select TOP 20000 Cast(Casting_Date as varchar) as periode, No_Produksi, No_Mould, S_Slurry, SS_Density, W_Slurry, WS_Density, Water, Cement, Lime, Alumunium, Temperature, ID from GEmixingp3 WHERE S_Slurry>1000 ORDER BY Datetime desc)as a GROUP BY periode order by periode desc")
        } else if (periode == 'monthly') {
            return pools.request().query("select periode,  CAST(MIN(No_Produksi) as varchar)+' - '+CAST(MAX(No_Produksi) as varchar) as No_Produksi, COUNT(No_Mould) as No_Mould, Cast(ROUND(AVG(S_Slurry),2) as Numeric(10,2)) as S_Slurry, Cast(ROUND(AVG(SS_Density),2) as Numeric(10,2)) as SS_Density, Cast(ROUND(AVG(W_Slurry),2) as Numeric(10,2)) as W_Slurry, Cast(Round(AVG(WS_Density),2) as Numeric(10,2)) as WS_Density, Cast(Round(AVG(Water),2) as Numeric(10,2)) as Water, Cast(ROUND(AVG(Cement),2) as Numeric(10,2)) as Cement, Cast(Round(AVG(Lime),2) as Numeric(10,2)) as Lime, Cast(Round(AVG(Alumunium),2) as Numeric(10,2)) as Alumunium, Cast(Round(AVG(Temperature),2) as Numeric(10,2)) as Temperature, '-' as ID from (select TOP 20000 Cast(Year(Casting_Date) as varchar)+'-'+RIGHT('0'+Cast(Month(Casting_Date) as varchar),2) as periode, No_Produksi, No_Mould, S_Slurry, SS_Density, W_Slurry, WS_Density, Water, Cement, Lime, Alumunium, Temperature, ID from GEmixingp3 WHERE S_Slurry>1000 ORDER BY Datetime desc)as a GROUP BY periode order by periode desc")
        } else {
            return res.status(204).send({
                message: `Periode yang anda masukkan tidak sesuai`,
                data: null
            })
        }
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

/**
 * @swagger
 * /dataproduksi3:
 *  get:
 *      summary: api untuk load data produksi plant 3
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
    /// using pool configuration
    pool.connect().then(pools => {
        /// execution query
        return pools.request().query("select TOP 5 GEmixingp3.Datetime, Cast(GEmixingp3.Casting_Date as varchar) as periode, GEmixingp3.No_Produksi, GEmixingp3.No_Mould, S_Slurry, SS_Target, GEmixingp3.SS_Density, W_Slurry, WS_Target, GEmixingp3.WS_Density, Water, Cement, Cement_Target, Lime, Lime_Target, GEmixingp3.Alumunium, GEmixingp3.Temperature, GEmixingp3.ID, Formula_Code as FC, c.No_autoclave as autoc_no, c.Autoclave_In as autoc_in, c.Autoclave_Out as autoc_out, End_Height as endh from GEmixingp3, Masterdatarecipe b, GEmainprosesp3 c where GEmixingp3.ID_Recipe=b.ID and Gemixingp3.No_Produksi=c.No_Produksi ORDER BY GEmixingp3.Datetime desc")
    }).then(response => {
        /// return data when success execute
        return res.status(200).send({
            message: "Data berhasil fetch.",
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
        console.log('Data Produksi Done!')
        pool.close()
    })
}

/**
 * @swagger
 * /analisaproduksi3:
 *  get:
 *      summary: api untuk load data analisa produksi plant 3
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

async function getDataAutoclavePlant3(req, res) {
    var nomin = req.body.nomin
    var nomax = req.body.nomax
    var timemin = req.body.timemin
    var timemax = req.body.timemax
    /// using pool configuration
    pool.connect().then(pools => {
        /// execution query
        /// condition when parameter null will be call all data without filter
        if (nomin != 'all' || nomax != 'all' || timemin != 'all' || timemax != 'all') {
            // return pools.request().query(';with autoc as (select *, ROW_NUMBER() over (Partition By autoclave_id order by datetime Desc) as rn from GEautoclave where autoclave_id<8) select autoc.datetime, Masternoautoclave.no_autoclave as noautoc, pressure, temperature from autoc, Masternoautoclave where autoc.autoclave_id=Masternoautoclave.autoclave_id and rn<=1000;')
            return pools.request().query(";with autoc as (select *, ROW_NUMBER() over (Partition By autoclave_id order by datetime Desc) as rn from GEautoclave where autoclave_id<8) select autoc.datetime, Masternoautoclave.no_autoclave as noautoc, pressure, temperature from autoc, Masternoautoclave where autoc.autoclave_id=Masternoautoclave.autoclave_id  AND Masternoautoclave.no_autoclave between '" + nomin + "' and '" + nomax + "' AND datetime between '" + timemin + "' and '" + timemax + "'")
        } else {
            return pools.request().query(';with autoc as (select *, ROW_NUMBER() over (Partition By autoclave_id order by datetime Desc) as rn from GEautoclave where autoclave_id<8) select autoc.datetime, Masternoautoclave.no_autoclave as noautoc, pressure, temperature from autoc, Masternoautoclave where autoc.autoclave_id=Masternoautoclave.autoclave_id and rn<=1000;')
        }
    }).then(response => {
        /// return data when success execute
        return res.status(200).send({
            message: `Data berhasil fetch.`,
            data: response.recordsets
        })
    }).catch(error => {
        console.log(error)
        /// return error result when error
        return res.status(500).send({
            message: "Masalah internal server",
            data: error
        })
    }).finally(() => {
        /// close pool connection to reduce queue query
        console.log('Data Autoclave Done!')
        pool.close()
    })
}

module.exports = {
    getDataAnalisaProduksiPlant3,
    getDataProduksiPlant3,
    getDataAutoclavePlant3
}