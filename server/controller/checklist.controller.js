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
 *  name: Checklist
 *  description: Api untuk Checklist pemeriksaan mesin
 */

/**
 * @swagger
 * /checklist/:idmesin:
 *  get:
 *      summary: api untuk load data checklist berdasarkan idmesin
 *      tags: [Checklist]
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

function getChecklist(req, res) {
  console.log("Load Checklist...");
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message:
          "Pool refushed, sorry :(, please try again or contact developer.",
        data: error,
      });
    } else {
      var sqlquery = `SELECT m.nomesin, m.keterangan as ketmesin, c.idchecklist, c.deskripsi, c.keterangan, c.dikerjakan_oleh, c.diperiksa_oleh, DATE_FORMAT( c.tanggal_checklist, "%Y-%m-%d") as tanggal_checklist, c.no_dokumen, c.idmesin FROM checklist c, mesin m WHERE c.idmesin=m.idmesin;`;
      database.query(sqlquery, (error, rows) => {
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
 * /checklist:
 *  post:
 *      summary: menambah data Checklist
 *      tags: [Checklist]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  deskripsi:
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  dikerjakan_oleh:
 *                      type: string
 *                  diperiksa_oleh:
 *                      type: integer
 *                  tanggal_checklist:
 *                      type: date
 *                  revisi:
 *                      type: integer
 *                  idmesin:
 *                      type: integer
 *                  no_dokumen:
 *                      type: string
 *                  tanggal_periksa:
 *                      type: datetime
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

async function addChecklist(req, res, datatoken) {
  var deskripsi = req.body.deskripsi;
  var keterangan = req.body.keterangan;
  var dikerjakan_oleh = req.body.dikerjakan_oleh;
  var diperiksa_oleh = req.body.diperiksa_oleh;
  var tanggal_checklist = req.body.tanggal_checklist;
  var revisi = req.body.revisi;
  var idmesin = req.body.idmesin;
  var no_dokumen = req.body.no_dokumen;
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        let datachecklist = {
          deskripsi: deskripsi,
          keterangan: keterangan,
          dikerjakan_oleh: dikerjakan_oleh,
          diperiksa_oleh: diperiksa_oleh,
          tanggal_checklist: tanggal_checklist,
          revisi:revisi,
          idmesin: idmesin,
          no_dokumen: no_dokumen,
          created: nows,
          idpengguna: datatoken.idpengguna,
        };
        var sqlquery = "INSERT INTO checklist SET ?";
        
        database.query(sqlquery, datachecklist, (error, result) => {
          database.release();
          console.log("CHECKLIST?", result, error)
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
                  data: result.insertId
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
 * /checklist/:idchecklist:
 *  put:
 *      summary: mengubah data Checklist
 *      tags: [Checklist]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  deskripsi:
 *                      type: string
 *                  keterangan:
 *                      type: string
 *                  dikerjakan_oleh:
 *                      type: string
 *                  diperiksa_oleh:
 *                      type: integer
 *                  tanggal_checklist:
 *                      type: date
 *                  revisi:
 *                      type: integer
 *                  idmesin:
 *                      type: integer
 *                  no_dokumen:
 *                      type: string
 *                  tanggal_periksa:
 *                      type: datetime
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

async function editChecklist(req, res, datatoken) {
  var deskripsi = req.body.deskripsi;
  var keterangan = req.body.keterangan;
  var dikerjakan_oleh = req.body.dikerjakan_oleh;
  var diperiksa_oleh = req.body.diperiksa_oleh;
  var tanggal_checklist = req.body.tanggal_checklist;
  var revisi = req.body.revisi;
  var idmesin = req.body.idmesin;
  var no_dokumen = req.body.no_dokumen;
  var idchecklist = req.params.idchecklist;
  if (idchecklist == "") {
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
        let datachecklist = {
          deskripsi: deskripsi,
          keterangan: keterangan,
          dikerjakan_oleh: dikerjakan_oleh,
          diperiksa_oleh: diperiksa_oleh,
          tanggal_checklist: tanggal_checklist,
          revisi: revisi,
          idmesin: idmesin,
          no_dokumen: no_dokumen,
          edited: nows,
          idpengguna: datatoken.idpengguna,
        };
        console.log(datachecklist,idchecklist);
        var sqlquery = "UPDATE checklist SET ? WHERE idchecklist = ?";
        database.query(
          sqlquery,
          [datachecklist, idchecklist],
          (error, result) => {
            console.log(result)
            database.release();
            if (error) {
              database.rollback(function () {
                console.log(error);
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
                    message: "Data Berhasil diperbarui!",
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
 * /checklist/:idchecklist:
 *  delete:
 *      summary: Menghapus data Checklist
 *      tags: [Checklist]
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

async function deleteChecklist(req, res) {
  var idchecklist = req.params.idchecklist;
  console.log("Hapus Checklist...");
  if (idchecklist == "") {
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
        /// delete checklist detail first
        var sqlquery = "DELETE FROM checklist_detail WHERE idchecklist = ?";
        database.query(sqlquery, [idchecklist]);
        /// delete data checklist then
        var sqlquery = "DELETE FROM checklist WHERE idchecklist = ?";
        database.query(sqlquery, [idchecklist], (error, result) => {
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

/**
 * @swagger
 * /detchecklist/:idchecklist:
 *  get:
 *      summary: api untuk load data checklist berdasarkan idmesin
 *      tags: [Checklist]
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

function getDetChecklist(req, res) {
  const idchecklist = req.params.idchecklist;
  console.log("Load Det Checklist...");
  if (idchecklist == "") {
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
      var sqlquery = `SELECT k.nama as komponen, k.kategori, m.keterangan as ketmesin, m.nomesin, cd.keterangan as keterangan_detchecklist, cd.action_checklist, cd.idcheklist FROM checklist_detail cd, komponen k, mesin m WHERE cd.idkomponen=k.idkomponen AND cd.idchecklist = ? AND k.idmesin=m.idmesin;`;
      database.query(sqlquery, idchecklist, (error, rows) => {
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
 * /detchecklist:
 *  post:
 *      summary: menambah data Checklist
 *      tags: [Checklist]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  idkomponen:
 *                      type: int
 *                  keterangan:
 *                      type: string
 *                  action_checklist:
 *                      type: string
 *                  tanggal:
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

async function addDetChecklist(req, res, datatoken) {
  var array = req.body.array
  console.log(array);
  pool.getConnection(function (error, database) {
    if (error) {
      return res.status(400).send({
        message: "Sorry, Pool Refushed",
        data: error,
      });
    } else {
      database.beginTransaction(function (error) {
        var sqlquery =
          "INSERT INTO checklist_detail (idkomponen, keterangan, action_checklist, idchecklist) VALUES ?";
        database.query(sqlquery, [array], (error, result) => {
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
 * /derchecklist/:idchecklist:
 *  delete:
 *      summary: Menghapus data Detail Checklist
 *      tags: [Checklist]
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

 async function deleteDetChecklist(req, res) {
  var idchecklist = req.params.idchecklist;
  console.log("Hapus Detail Checklist...");
  if (idchecklist == "") {
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
        var sqlquery = "DELETE FROM checklist_detail WHERE idchecklist = ?";
        database.query(sqlquery, [idchecklist], (error, result) => {
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
  getChecklist,
  addChecklist,
  editChecklist,
  deleteChecklist,
  getDetChecklist,
  addDetChecklist,
  deleteDetChecklist
};
