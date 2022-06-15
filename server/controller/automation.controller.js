require("dotenv").config();
var { pool } = require("../utils/poolsqlserver.configuration");

/**
 * @swagger
 * tags:
 *  name: Automation
 *  description: Api untuk Automation
 */

/**
 * @swagger
 * /pushdatamould:
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

async function pushdatamould(req, res) {
  const { site, nomould } = req.params;
  /// using pool configuration
  pool
    .connect()
    .then((pools) => {
      /// execution query
      /// filtering query with site and plant
      switch (site) {
        case "mixing":
          pools.request().query("");
          break;
        case "xxx":
          pools.request().query("");
          break;
        default:
          return res.status(400).send({
            message: `Site tidak diketahui`,
            data: "",
          });
      }
    })
    .then((response) => {
      /// return data when success execute
      return res.status(200).send({
        message: `Data ${nomould} berhasil disimpan.`,
        data: response.recordsets,
      });
    })
    .catch((error) => {
      /// return error result when error
      return res.status(500).send({
        message: "Masalah internal server",
        data: error,
      });
    })
    .finally(() => {
      /// close pool connection to reduce queue query
      console.log("Data Analisa Produksi Done!");
      pool.close();
    });
}

module.exports = {
  pushdatamould,
};
