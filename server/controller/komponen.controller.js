require("dotenv").config();
var pool = require("../utils/pool.configuration");
var nows = {
  toSqlString: function () {
    return "NOW()";
  },
};

/**
 * @swagger
 * tags:
 *  name: Komponen
 *  description: Api untuk Komponen Mesin
 */

/**
 * @swagger
 * /komponen/:idmesin:
 *  get:
 *      summary: api untuk load data komponen by mesin
 *      tags: [Komponen]
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

function getKomponen(req, res) {
  var idmesin = req.params.idmesin;
  if (idmesin == "") {
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
      var sqlquery = "SELECT k.*, k.keterangan as ketkomponen, m.nomesin, m.keterangan FROM komponen k, mesin m WHERE k.idmesin=m.idmesin and m.idmesin = ?";
      database.query(sqlquery, idmesin, (error, rows) => {
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
 * /komponen:
 *  post:
 *      summary: menambah data Komponen
 *      tags: [Komponen]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nama:
 *                      type: string
 *                  kategori:
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  flag_reminder:
 *                      type: integer
 *                  jumlah_reminder:
 *                      type: integer
 *                  idmesin:
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

async function addKomponen(req, res, datatoken) {
  var nama = req.body.nama;
  var kategori = req.body.kategori;
  var keterangan = req.body.keterangan;
  var flag_reminder = req.body.flag_reminder;
  var jumlah_reminder = req.body.jumlah_reminder;
  var idmesin = req.body.idmesin;
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datakomponen = {
          nama: nama,
          kategori: kategori,
          keterangan: keterangan,
          flag_reminder: flag_reminder,
          jumlah_reminder: jumlah_reminder,
          idmesin: idmesin,
          created: nows,
          idpengguna: datatoken.idpengguna,
        };
        var sqlquery = "INSERT INTO komponen SET ?";
        database.query(sqlquery, datakomponen, (error, result) => {
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
                return res.status(201).send({
                  message: "Data Berhasil disimpan!",
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
 * /komponen/:idkomponen:
 *  put:
 *      summary: mengubah data Komponen
 *      tags: [Komponen]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  nama:
 *                      type: string
 *                  kategori:
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  flag_reminder:
 *                      type: integer
 *                  jumlah_reminder:
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
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password
 *          500:
 *              description: kesalahan pada query sql
 */

async function editKomponen(req, res, datatoken) {
  var idkomponen = req.params.idkomponen;
  var nama = req.body.nama;
  var kategori = req.body.kategori;
  var keterangan = req.body.keterangan;
  var flag_reminder = req.body.flag_reminder;
  var jumlah_reminder = req.body.jumlah_reminder;
  var idmesin = req.body.idmesin;
  if (idkomponen == "") {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Soory, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datakomponen = {
          nama: nama,
          kategori: kategori,
          keterangan: keterangan,
          flag_reminder: flag_reminder,
          jumlah_reminder: jumlah_reminder,
          idmesin: idmesin,
          created: nows,
          idpengguna: datatoken.idpengguna,
        };
        var sqlquery = "UPDATE komponen SET ? WHERE idkomponen = ?";
        database.query(
          sqlquery,
          [datakomponen, idkomponen],
          (error, result) => {
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
                  database.release();
                  return res.status(200).send({
                    message: "Data berhasil diperbarui!",
                  });
                }
              });
            }
          }
        );
      });
    }
  });
}

/**
 * @swagger
 * /komponen/:idkomponen:
 *  delete:
 *      summary: Menghapus data komponen
 *      tags: [Komponen]
 *      consumes:
 *          - application/json
 *      responses:
 *          200:
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

async function deleteKomponen(req, res) {
  var idkomponen = req.params.idkomponen;
  if (idkomponen == "" || flag_activity == "") {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Soory, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        var sqlquery = "DELETE FROM komponen WHERE idkomponen = ?";
        database.query(sqlquery, [idkomponen], (error, result) => {
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
                    message: "data gagal menghapus!",
                  });
                });
              } else {
                database.release();
                return res.status(200).send({
                  message: "Data berhasil dihapus!",
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
  getKomponen,
  addKomponen,
  editKomponen,
  deleteKomponen,
};
