//Plugin
require("dotenv").config();
const jwt = require("jsonwebtoken");
var pool = require("../utils/pool.configuration");
var nows = {
  toSqlString: function () {
    return "NOW()";
  },
};

/**
 * @swagger
 * tags:
 *  name: Validation
 *  description: Api untuk Login and validation
 */

/**
 * @swagger
 * /login:
 *  post:
 *      summary: Untuk login validasi aplikasi cmms
 *      tags: [Validation]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: body
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  username:
 *                      type: string
 *                  password:
 *                      type: string
 *                  device:
 *                      type: string
 *                  appversion:
 *                      type: integer
 *                  uuid:
 *                      type: integer
 *                  ipclient:
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

async function Login(req, res) {
  var username = req.body.username;
  var password = req.body.password;
  var device = req.body.device;
  var appversion = req.body.appversion;
  var uuid = req.body.uuid;
  var ipclient = req.socket.remoteAddress;
  console.log(
    username,
    password,
    device,
    appversion,
    uuid,
    ipclient.split("f:")[1]
  );
  console.log(
    appversion < process.env.API_VERSION,
    appversion,
    process.env.API_VERSION
  );
  /// checkin app version and api version
  if (appversion < process.env.API_VERSION) {
    return res.status(401).send({
      message:
        "Sorry 😞, your apps too old, please update your apps or report to administrator.",
      error: null,
      data: null,
    });
  } else {
    try {
      pool.getConnection(function (error, database) {
        if (error) {
          return res.status(501).send({
            message: "Sorry, Pool Refushed",
            data: error,
          });
        } else {
          var filterdevice = "";
          if (device == "WEBAPI") {
            if (uuid == process.env.UUIDWEB) {
            } else {
              return res.status(401).send({
                message: "Sorry, WEB UUID not match!",
                data: error,
              });
            }
          } else {
            filterdevice = " and newuuid='" + uuid + "'";
          }
          var sqlquery =
            "SELECT idpengguna, username, password, jabatan, nama, aktif FROM pengguna WHERE username = ? and password = ? ";
          database.query(
            sqlquery,
            [username, password],
            function (error, rows) {
              // database.release()
              if (error) {
                return res.status(407).send({
                  message: "Sorry, sql query have problems",
                  data: error,
                });
              } else {
                if (!rows.length) {
                  return res.status(400).send({
                    message: "Username atau Password anda salah!",
                    data: null,
                  });
                } else if (rows[0].aktif == 0) {
                  return res.status(200).send({
                    message: "Akun anda tidak aktif",
                    data: null,
                  });
                } else {
                  console.log("Login Berhasil");
                  const user = {
                    idpengguna: rows[0].idpengguna,
                    device: device,
                    appversion: appversion,
                    uuid: uuid,
                  };
                  const access_token = jwt.sign(
                    user,
                    process.env.ACCESS_SECRET,
                    {
                      expiresIn: process.env.ACCESS_EXPIRED,
                    }
                  );
                  let datalogpengguna = {
                    tipe: device,
                    idpengguna: rows[0].idpengguna,
                    login_time: nows,
                    ipaddress: ipclient.split("f:")[1],
                  };
                  var sqlquery = "INSERT INTO log_pengguna SET ?";
                  database.query(
                    sqlquery,
                    datalogpengguna,
                    (error, resultlog) => {
                      database.release();
                      if (resultlog) {
                        return res.status(200).send({
                          message: "Selamat, Anda Berhasil Login",
                          data: {
                            access_token: access_token,
                            username: rows[0].nama,
                            jabatan: rows[0].jabatan,
                            aktif: rows[0].aktif + "-" + rows[0].idpengguna,
                          },
                        });
                      } else {
                        return res.status(200).send({
                          message:
                            "Selamat, Anda Berhasil Login, tidak terlog!",
                          data: {
                            access_token: access_token,
                            username: rows[0].nama,
                            jabatan: rows[0].jabatan,
                            aktif: rows[0].aktif + "-" + rows[0].idpengguna,
                          },
                        });
                      }
                    }
                  );
                }
              }
            }
          );
        }
      });
    } catch (error) {
      return res.status(403).send({
        message: "Forbidden",
        error: error,
      });
    }
  }
}

/**
 * @swagger
 * /cekvalidasi/:token:
 *  get:
 *      summary: untuk pengecekan token validasi web
 *      tags: [Validation]
 *      consumes:
 *          - application/json
 *      parameters:
 *          - in: path
 *            name: parameter yang dikirim
 *            schema:
 *              properties:
 *                  token:
 *                      type: string
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

function cekingToken(req, res) {
  var token = req.params.token;
  if (token == "") {
    return res.status(400).send({
      message: "Parameter doesn't match!",
      data: null,
    });
  }
  try {
    jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
      console.log(jwterror, jwtresult);
      if (jwtresult) {
        pool.getConnection(function (error, database) {
          if (error) {
            return res.status(400).send({
              message:
                "Pool refushed, sorry :(, try again or contact developer",
              data: error,
            });
          } else {
            var sqlquery =
              "SELECT nama, jabatan, aktif FROM pengguna where idpengguna = ?";
            database.query(sqlquery, jwtresult.idpengguna, (error, rows) => {
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
      } else {
        return res.status(401).send({
          message: "Sorry, Token tidak validx!",
          data: jwterror,
        });
      }
    });
  } catch (error) {
    res.status(403).send({
      message: "Forbidden",
      error: error,
    });
  }
}

module.exports = {
  Login,
  cekingToken,
};
