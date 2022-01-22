//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
const mysql = require('mysql')
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    timezone: 'utc-8'
})
var fs = require('fs')

async function Login(req, res) {
    var username = req.body.username;
    var password = req.body.password;
    var tipe = req.body.tipe;
    console.log('Ada yang mencoba masuk', Object.keys(req.body).length)
    if (Object.keys(req.body).length != 3) {
        res.status(405).send({
            message: "Parameter tidak sesuai",
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
                    var sqlquery = "SELECT idpengguna, username, password, jabatan, nama, aktif FROM pengguna WHERE username = ? and password = ?"
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
                                };
                                const access_token = jwt.sign(user, process.env.ACCESS_SECRET, {
                                    expiresIn: process.env.ACCESS_EXPIRED
                                })
                                fs.appendFile('notificationlog.txt',  `[ ${tipe} ] `+new Date().getUTCMinutes+` [ Login ] - ${username}\n`, function (err){
                                    if(err){
                                        console.log('gagal')
                                    }else{
                                        console.log('berhasil')        
                                    }
                                })
                                return res.status(200).send({
                                    message: 'Selamat, Anda Berhasil Login',
                                    data: {
                                        access_token: access_token,
                                        username: rows[0].nama,
                                        jabatan: rows[0].jabatan,
					aktif: rows[0].aktif+'-'+rows[0].idpengguna
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
    console.log(token)
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
