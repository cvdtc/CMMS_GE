require("dotenv").config();
const fcmadmin = require("../utils/firebase.configuration");
var pool = require("../utils/pool.configuration");

var nows = {
  toSqlString: function () {
    return "NOW()";
  },
};

/**
 * @swagger
 * tags:
 *  name: Masalah
 *  description: Api untuk Masalah
 */

/**
 * @swagger
 * /masalah/:flag_activity/:idsite/:tanggal_awal/:tanggal_akhir:
 *  get:
 *      summary: api untuk load data masalah berdasarkan flag_activity jika 0 maka akan meload data pre-activity jika 1 maka load data activity
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  flag_activity:
 *                      type: integer
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

function getMasalah(req, res) {
  var flag_activity = req.params.flag_activity;
  var filter_site = req.params.filter_site;
  var tanggal_awal = req.params.tanggal_awal;
  var tanggal_akhir = req.params.tanggal_akhir;
  console.log(flag_activity, filter_site);
  if (
    filter_site == "" ||
    flag_activity == "" ||
    tanggal_awal == "" ||
    tanggal_akhir == ""
  ) {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message:
          "Pool refushed, sorry :(, please try again or contact developer.",
        data: error,
      });
    } else {
      filtersite = "";
      filtertanggal = "";
      /// filter idsite  if idsite 0  will be execute all site
      if (filter_site != 0) filtersite = "AND ms.idsite = " + filter_site;
      /// filter periodic tanggal masalah with parameters tanggal_awal and tanggal_akhir with format yyyy-mm-dd
      if (tanggal_awal != 0 && tanggal_akhir != 0) {
        filtertanggal = "BETWEEN '"+tanggal_awal+"' AND '"+tanggal_akhir+"'";
      } else {
        filtertanggal = "> date_sub(now(), INTERVAL 4 MONTH)";
      }
      console.log(filtertanggal)
      var sqlquery =
        `SELECT * FROM (SELECT m.idmasalah, m.jam, DATE_FORMAT( m.tanggal, "%Y-%m-%d") as tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as statusselesai, DATE_FORMAT( m.created, "%Y-%m-%d %H:%i") as created, m.jenis_masalah, m.flag_activity, pe.nama as pengguna FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite INNER JOIN pengguna pe ON m.idpengguna=pe.idpengguna WHERE m.flag_activity = ? ` +
        filtersite +
        ` AND m.tanggal ` +
        filtertanggal +
        ` ORDER BY m.tanggal DESC)a ORDER BY a.statusselesai ASC, a.created DESC;`;
        console.log(sqlquery);
      database.query(sqlquery, flag_activity, (error, rows) => {
        database.release();
        console.log("masalah", rows);
        if (error) {
          return res.status(500).send({
            message: "Sorry :(, my query has been error",
            data: error,
          });
        } else {
          if (rows.length <= 0) {
            return res.status(204).send({
              message: "Data masih kosong",
              data: rows,
            });
          } else {
            return res.status(200).send({
              message: "Data berhasil fetch.",
              data: rows,
            });
          }
        }
      });
    }
  });
}

/**
 * @swagger
 * /masalah/:flag_activity/:idmesin:
 *  get:
 *      summary: api untuk load data masalah berdasarkan flag_activity dan idmesin
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  flag_activity:
 *                      type: integer
 *                  idmesin:
 *                      type: integer
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

function getMasalahByMesin(req, res) {
  var idmesin = req.params.idmesin;
  var flag_activity = req.params.flag_activity;
  if (idmesin == "" || flag_activity == "") {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Pool refushed, sorry :(, try again or contact developer",
        data: error,
      });
    } else {
      var sqlquery = `SELECT * FROM (SELECT m.idmasalah, m.jam, DATE_FORMAT( m.tanggal, "%Y-%m-%d") as tanggal, m.masalah, m.shift, m.idmesin, m.idpengguna, ms.nomesin, ms.keterangan as ketmesin, s.nama as site, ifnull(p.idpenyelesaian,'-') as idpenyelesaian, if(p.idpenyelesaian is null, 0, 1) as statusselesai, DATE_FORMAT( m.created, "%Y-%m-%d %H:%i") as created, m.jenis_masalah, m.flag_activity, pe.nama as pengguna FROM masalah m LEFT JOIN penyelesaian p ON m.idmasalah=p.idmasalah INNER JOIN mesin ms ON m.idmesin=ms.idmesin INNER JOIN site s ON ms.idsite=s.idsite INNER JOIN pengguna pe ON m.idpengguna=pe.idpengguna WHERE m.flag_activity = ? AND m.idmesin = ? AND m.tanggal > date_sub(now(), INTERVAL 4 MONTH) ORDER BY m.tanggal DESC)a ORDER BY a.statusselesai ASC;`;
      database.query(sqlquery, [flag_activity, idmesin], (error, rows) => {
        database.release();
        if (error) {
          return res.status(500).send({
            message: "Sorry :(, my query has been error",
            data: error,
          });
        } else {
          if (rows.length <= 0) {
            return res.status(204).send({
              message: "Data masih kosong",
              data: rows,
            });
          } else {
            return res.status(200).send({
              message: "Data berhasil fetch.",
              data: rows,
            });
          }
        }
      });
    }
  });
}

/**
 * @swagger
 * /masalah:
 *  post:
 *      summary: menambah data Masalah
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  masalah:
 *                      type: string
 *                  tanggal:
 *                      type: string
 *                  jam:
 *                      type: string
 *                  idmesin:
 *                      type: integer
 *                  shift:
 *                      type: integer
 *                  jenis_masalah:
 *                      type: string
 *                  flag_activity:
 *                      type: integer
 *      responses:
 *          201:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password
 *          500:
 *              description: kesalahan pada query sql
 */

async function addMasalah(req, res, datatoken) {
  var masalah = req.body.masalah;
  var tanggal = req.body.tanggal;
  var jam = req.body.jam;
  var idmesin = req.body.idmesin;
  var shift = req.body.shift;
  var jenis_masalah = req.body.jenis_masalah;
  var flag_activity = req.body.flag_activity;
  console.log("Mencoba insert...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datamasalah = {
          masalah: masalah,
          tanggal: tanggal,
          jam: jam,
          idmesin: idmesin,
          shift: shift,
          jenis_masalah: jenis_masalah,
          flag_activity: flag_activity,
          created: nows,
          timestamp: nows, /// untuk update field lama, aplikasi baru tidak dipakai!
          idpengguna: datatoken.idpengguna,
        };
        var sqlquery = "INSERT INTO masalah SET ?";
        database.query(sqlquery, datamasalah, (error, result) => {
          if (error) {
            database.rollback(function () {
              database.release();
              return res.status(407).send({
                message: "Sorry :(, we have problems sql query!",
                error: error,
              });
            });
          } else {
            database.commit(function (errcommit) {
              if (errcommit) {
                database.rollback(function () {
                  database.release();
                  return res.status(407).send({
                    message: "data gagal disimpan!",
                  });
                });
              } else {
                var getmesin =
                  "SELECT nomesin, keterangan FROM mesin WHERE idmesin = ?";
                database.query(getmesin, idmesin, (error, result) => {
                  database.release();
                  // * set firebase notification message
                  let notificationMessage = {
                    notification: {
                      title: `Ada Masalah pada ${result[0].keterangan} ( ${result[0].nomesin} )`,
                      body: masalah,
                      sound: "default",
                      click_action: "FLUTTER_CLICK_ACTION",
                    },
                    data: {
                      judul: `Ada Masalah pada ${result[0].keterangan} ( ${result[0].nomesin} )`,
                      isi: masalah,
                    },
                  };
                  // * sending notification topic RMSPERMINTAAN
                  fcmadmin
                    .messaging()
                    .sendToTopic("CMMSMASALAH", notificationMessage)
                    .then(function (response) {
                      return res.status(201).send({
                        message: "Done!,  Data berhasil disimpan!",
                      });
                    })
                    .catch(function (error) {
                      return res.status(201).send({
                        message:
                          "Done!,  Data has been stored!, but notification can't send to topic.",
                      });
                    });
                });
              }
            });
          }
        });
      });
    }
  });
}

/**
 * @swagger
 * /masalah/:idmasalah:
 *  put:
 *      summary: mengubah data Masalah
 *      tags: [Masalah]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  masalah:
 *                      type: string
 *                  tanggal:
 *                      type: string
 *                  jam:
 *                      type: string
 *                  idmesin:
 *                      type: int
 *                  shift:
 *                      type: int
 *                  jenis_masalah:
 *                      type: string
 *      responses:
 *          201:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password
 *          500:
 *              description: kesalahan pada query sql
 */

async function editMasalah(req, res, datatoken) {
  var idmasalah = req.params.idmasalah;
  var masalah = req.body.masalah;
  var tanggal = req.body.tanggal;
  var jam = req.body.jam;
  var idmesin = req.body.idmesin;
  var shift = req.body.shift;
  var flag_activity = req.body.flag_activity;
  var jenis_masalah = req.body.jenis_masalah;
  console.log(" edit masalah...");
  if (idmasalah == "") {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datamasalah = {
          masalah: masalah,
          tanggal: tanggal,
          jam: jam,
          idmesin: idmesin,
          shift: shift,
          jenis_masalah: jenis_masalah,
          flag_activity: flag_activity,
          edited: nows,
          idpengguna: datatoken.idpengguna,
        };
        var sqlquery = "UPDATE masalah SET ? WHERE idmasalah = ?";
        database.query(sqlquery, [datamasalah, idmasalah], (error, result) => {
          database.release();
          if (error) {
            database.rollback(function () {
              return res.status(407).send({
                message: "Sorry :(, we have problems sql query!",
                error: error,
              });
            });
          } else {
            database.commit(function (errcommit) {
              if (errcommit) {
                database.rollback(function () {
                  return res.status(407).send({
                    message: "data gagal disimpan!",
                  });
                });
              } else {
                return res.status(200).send({
                  message: "Data berhasil disimpan!",
                });
              }
            });
          }
        });
      });
    }
  });
}

module.exports = {
  getMasalah,
  getMasalahByMesin,
  addMasalah,
  editMasalah,
};
