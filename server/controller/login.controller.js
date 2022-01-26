//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
var pool = require('../utils/pool.configuration')
var fs = require('fs')

async function Login(req, res) {
    var username = req.body.username
    var password = req.body.password
    var device = req.body.device
    var appversion = req.body.appversion
    var uuid = req.body.uuid
    console.log(username, password, device, appversion, uuid)
    console.log(appversion < process.env.API_VERSION, appversion, process.env.API_VERSION)
    /// checkin app version and api version
    if (appversion < process.env.API_VERSION) {
        return res.status(401).send({
            message: 'Sorry 😞, your apps too old, please update your apps or report to administrator.',
            error: null,
            data: null
        })
    } else {
        try {
            pool.getConnection(function (error, database) {
                if (error) {
                    res.status(501).send({
                        message: "Sorry, Pool Refushed",
                        data: error
                    })
                } else {
                    var filterdevice = ""
                    if (device != "WEBAPI") filterdevice = " and newuuid='" + uuid + "'"
                    //                    var sqlquery = "SELECT idpengguna, username, password, jabatan, nama, aktif FROM pengguna WHERE username = ? and password = ? and newuuid = ?"
                    //                    database.query(sqlquery, [username, password, uuid], function (error, rows) {
                    var sqlquery = "SELECT idpengguna, username, password, jabatan, nama, aktif FROM pengguna WHERE username = ? and password = ? "
                    database.query(sqlquery, [username, password], function (error, rows) {
                        database.release()
                        if (error) {
                            res.status(407).send({
                                message: "Sorry, sql query have problems",
                                data: error
                            })
                        } else {
                            if (!rows.length) {
                                res.status(400).send({
                                    message: "Username atau Password anda salah!",
                                    data: null
                                });
                            } else if (rows[0].aktif == 0) {
                                res.status(200).send({
                                    message: "Akun anda tidak aktif",
                                    data: null
                                });
                            } else {
                                console.log("Login Berhasil")
                                const user = {
                                    idpengguna: rows[0].idpengguna,
                                    device: device,
                                    appversion: appversion,
                                    uuid: uuid
                                };
                                const access_token = jwt.sign(user, process.env.ACCESS_SECRET, {
                                    expiresIn: process.env.ACCESS_EXPIRED
                                })
                                fs.appendFile('notificationlog.txt', `[ ${device} ] ` + new Date().getUTCMinutes + ` [ Login ] - ${username}\n`, function (err) {
                                    if (err) {
                                        console.log('gagal')
                                    } else {
                                        console.log('berhasil')
                                    }
                                })
                                return res.status(200).send({
                                    message: 'Selamat, Anda Berhasil Login',
                                    data: {
                                        access_token: access_token,
                                        username: rows[0].nama,
                                        jabatan: rows[0].jabatan,
                                        aktif: rows[0].aktif + '-' + rows[0].idpengguna
                                    }
                                })
                            }
                        }
                    });
                }
            })
        } catch (error) {
            res.status(403).send({
                message: "Forbidden",
                error: error
            })
        }
    }
}

async function cekingToken(req, res) {
    var token = req.params.token
    try {
        jwt.verify(token, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            console.log(jwterror, jwtresult)
            if (jwtresult) {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Pool refushed, sorry :(, try again or contact developer",
                            data: error
                        })
                    } else {
                        var sqlquery = "SELECT nama, jabatan, aktif FROM pengguna where idpengguna = ?"
                        database.query(sqlquery, jwtresult.idpengguna, (error, rows) => {
                            database.release()
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry :(, my query has been error",
                                    data: error
                                })
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
                                        message: "Data masih kosong",
                                        data: rows
                                    })
                                } else {
                                    return res.status(200).send({
                                        message: "Data berhasil fetch.",
                                        data: rows
                                    })
                                }
                            }
                        })
                    }
                })
            } else {
                return res.status(401).send({
                    message: "Sorry, Token tidak validx!",
                    data: jwterror
                });
            }
        })
    } catch (error) {
        res.status(403).send({
            message: "Forbidden",
            error: error
        })
    }
}

module.exports = {
    Login,
    cekingToken
}
