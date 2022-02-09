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
 *  name: Checkout
 *  description: Api untuk Checkout Barang
 */

/**
 * @swagger
 * /checkout/:idmasalah:
 *  get:
 *      summary: api untuk load data checkout barang
 *      tags: [Checkout]
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

function getCheckout(req, res) {
  const idmasalah = req.params.idmasalah;
  console.log("Load Checkout...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message:
          "Pool refushed, sorry :(, please try again or contact developer.",
        data: error,
      });
    } else {
      var sqlquery = `SELECT c.idcheckout, c.idmasalah, c.idbarang, c.idsatuan, DATE_FORMAT( c.tanggal, "%Y-%m-%d") as tanggal, c.keterangan, c.qty, b.BB_NAMA as barang, b.BB_SATUAN as satuan, m.masalah, c.tgl_reminder, c.kilometer FROM checkout c, masalah m, bb b WHERE c.idmasalah=m.idmasalah and c.idbarang=b.BB_ID AND m.idmasalah = ?`;
      database.query(sqlquery, idmasalah, (error, rows) => {
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
 * /checkout:
 *  post:
 *      summary: menambah checkout barang
 *      tags: [Checkout]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  idmasalah:
 *                      type: integer
 *                  idbarang:
 *                      type: integer
 *                  idsatuan:
 *                      type: integer
 *                  tanggal:
 *                      type: date
 *                  qty:
 *                      type: integer
 *                  keterangan:
 *                      type: string
 *                  kilometer:
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

async function addCheckout(req, res) {
  var idmasalah = req.body.idmasalah;
  var idbarang = req.body.idbarang;
  var tanggal = req.body.tanggal;
  var idsatuan = req.body.idsatuan;
  var qty = req.body.qty;
  var keterangan = req.body.keterangan;
  var tgl_reminder = req.body.tgl_reminder; /// tidak dipakai karena otomatis memakai tanggal saat diinput
  var kilometer = req.body.kilometer;
  console.log("Insert checkout...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datacheckout = {
          idmasalah: idmasalah,
          idbarang: idbarang,
          tanggal: tanggal,
          idsatuan: idsatuan,
          qty: qty,
          keterangan: keterangan,
          tgl_reminder: nows,
          kilometer: kilometer,
          timestamp: nows,
        };
        var sqlquery = "INSERT INTO checkout SET ?";
        database.query(sqlquery, datacheckout, (error, result) => {
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
                  message: "Done!,  Data Berhasil disimpan!",
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
 * /checkout/:idcheckout:
 *  put:
 *      summary: mengubah data progress
 *      tags: [Checkout]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  idmasalah:
 *                      type: integer
 *                  idbarang:
 *                      type: integer
 *                  idsatuan:
 *                      type: integer
 *                  tanggal:
 *                      type: date
 *                  qty:
 *                      type: integer
 *                  keterangan:
 *                      type: string
 *                  tgl_reminder:
 *                      type: date
 *                  kilometer:
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

async function editCheckout(req, res) {
  var idcheckout = req.params.idcheckout;
  var idmasalah = req.body.idmasalah;
  var idbarang = req.body.idbarang;
  var tanggal = req.body.tanggal;
  var idsatuan = req.body.idsatuan;
  var qty = req.body.qty;
  var keterangan = req.body.keterangan;
  var tgl_reminder = req.body.tgl_reminder;
  var kilometer = req.body.kilometer;
  console.log("Mencoba edit...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datacheckout = {
          idmasalah: idmasalah,
          idbarang: idbarang,
          tanggal: tanggal,
          idsatuan: idsatuan,
          qty: qty,
          keterangan: keterangan,
          tgl_reminder: tgl_reminder,
          kilometer: kilometer,
          timestamp: nows,
        };
        var sqlquery = "UPDATE checkout SET ? WHERE idcheckout = ?";
        database.query(
          sqlquery,
          [datacheckout, idcheckout],
          (error, result) => {
            database.release();
            console.log(result);
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
 * /checkouttglreminder/:idcheckout:
 *  put:
 *      summary: mengubah tgl_reminder checkout
 *      tags: [Checkout]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  tgl_reminder:
 *                      type: date
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

async function editCheckoutTglReminder(req, res) {
  var idcheckout = req.params.idcheckout;
  var tgl_reminder = req.body.tgl_reminder;
  console.log("edit tgl reminder...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        var sqlquery =
          "UPDATE checkout SET tgl_reminder = ?, timestamp = ? WHERE idcheckout = ?";
        database.query(
          sqlquery,
          [tgl_reminder, nows, idcheckout],
          (error, result) => {
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
 * /checkout/:idcheckout:
 *  delete:
 *      summary: Menghapus data Checkout barang
 *      tags: [Checkout]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  idcheckout:
 *                      type: int
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

async function deleteCheckout(req, res) {
  var idcheckout = req.params.idcheckout;
  console.log("Hapus Checkout...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        var sqlquery = "DELETE FROM checkout WHERE idcheckout = ?";
        database.query(sqlquery, [idcheckout], (error, result) => {
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
  getCheckout,
  addCheckout,
  editCheckout,
  editCheckoutTglReminder,
  deleteCheckout,
};
