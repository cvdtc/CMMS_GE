require("dotenv").config();
var { pool } = require("../utils/poolsqlserver.configuration");

const fcmadmin = require("../utils/firebase.configuration");

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
  let { macaddress, nomould } = req.params;
  let koneksi;
  /// temporary initialize name of machine
  if (macaddress == "precuring") {
    macaddress = "cutting";
  }
  
  console.log(macaddress, nomould);
  // / using pool configuration
  pool
    .connect()
    .then((pools) => {
      /// execution query
      /// filtering query with site and plant
      /**
       * NOTE!
       * - update query add mac_address for handle multiple record @ site [22072022]
       */
      koneksi = pools;
      return pools
        .request()
        .query(
          `SELECT * FROM GEmould where no_mould = ${nomould} and mac_address='${macaddress}' and datetime >= dateadd(hour, -2, getdate());`
        );
      // return pools.request().query(`INSERT INTO GEmould (datetime, no_mould, mac_address) VALUES (GETDATE(), '${nomould}', '${macaddress}');`);
    })
    .then((response) => {
      /// checking when recordset is null will be insert data MOULD or when recordset not null data not store to GEmould
      if (response.recordset != "") {
        console.log(nomould, "Data mould sudah ada di database");
        return res.status(200).send({
          message: `Data ${nomould} sudah ada!.`,
          data: response,
        });
      } else {
        console.log(nomould, "Data mould tidak ada di database");
        /// insert data to GEmould without checking store success or not
        return koneksi
          .request()
          .query(
            `INSERT INTO GEmould (datetime, no_mould, mac_address) VALUES (GETDATE(), '${nomould}', '${macaddress}');`
          )
          .then((response) => {
            // console.log('??', response, response.rowsAffected[0])
            /// close connection sql server
            pool.close();

            /// notification handler
            // * set firebase notification message
            if (response.rowsAffected[0] != 0) {
              let notificationMessage = {
                notification: {
                  title: `Mould No ${nomould} memasuki ${macaddress}`,
                  body: `Pada ${Date.now()}`,
                  sound: "default",
                  click_action: "FCM_PLUGIN_ACTIVITY",
                },
                data: {
                  judul: `Mould No ${nomould} memasuki ${macaddress}`,
                  isi: `Pada ${Date.now()}`,
                },
              };
              // * sending notification topic RMSPERMINTAAN
              fcmadmin
                .messaging()
                .sendToTopic("CMMSMASALAH", notificationMessage)
                .then(function (response) {
                  return res.status(200).send({
                    message: `Data ${nomould} berhasil disimpan.`,
                    data: response,
                  });
                })
                .catch(function (error) {
                  return res.status(201).send({
                    message:
                      "Done!,  Data has been stored!, but notification can't send to topic.",
                  });
                });
            } else {
              console.log("multiple notification has been blocked!");
            }

            /// return response code
            // * close code bcz esp ca'nt process status code
            // return res.status(200).send({
            //   message: `Data ${nomould} berhasil disimpan.`,
            //   data: response,
            // });
          });
      }
    })
    .catch((error) => {
      console.log(error);
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
