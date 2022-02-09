require('dotenv').config()
const express = require('express')
const router = express.Router()
const jwtVerify = require('../utils/jwtverify.configuration')

// BARANG
var RouteToBarang = require('../controller/barang.controller')
router.get('/barang', jwtVerify, (req, res) => {
    RouteToBarang.getBarang(req, res)
})

//CHECKOUT
var RouteToCheckout = require('../controller/checkout.controller')
router.get('/checkout/:idmasalah', jwtVerify, function(req, res) {
    RouteToCheckout.getCheckout(req, res)
})
router.post('/checkout', jwtVerify, function(req, res) {
    RouteToCheckout.addCheckout(req, res)
})
router.put('/checkout/:idcheckout', jwtVerify, function(req, res) {
    RouteToCheckout.editCheckout(req, res)
})
router.put('/checkouttglreminder/:idcheckout', jwtVerify, function(req, res) {
    RouteToCheckout.editCheckoutTglReminder(req, res)
})
router.delete('/checkout/:idcheckout', jwtVerify, function(req, res) {
    RouteToCheckout.deleteCheckout(req, res)
})


//DASHBOARD
var RouteToDashbord = require('../controller/dashboard.controller')
router.get('/dashboard', jwtVerify, function(req, res) {
    RouteToDashbord.getDashboard(req, res)
})

//KOMPONEN
var RouteToKomponen = require('../controller/komponen.controller')
router.get('/komponen/:idmesin', jwtVerify, function(req, res) {
    RouteToKomponen.getKomponen(req, res)
})
router.post('/komponen', jwtVerify, function(req, res) {
    RouteToPenyelesaian.addPenyelesaian(req, res, req.decode)
})
router.put('/komponen/:idkomponen', jwtVerify, function(req, res) {
    RouteToPenyelesaian.editPenyelesaian(req, res, req.decode)
})
router.delete('/komponen/:idkomponen', jwtVerify, function(req, res) {
    RouteToPenyelesaian.deletePenyelesaian(req, res)
})

//LOGIN
var RouteToLogin = require('../controller/login.controller')
router.post('/login', function(req, res) {
    RouteToLogin.Login(req, res)
})
router.get('/cekvalidasi/:token', function(req, res) {
    RouteToLogin.cekingToken(req, res)
})

//MASALAH
var RouteToMasalah = require('../controller/masalah.controller')
router.get('/masalah/:flag_activity/:filter_site', jwtVerify, function(req, res) {
    RouteToMasalah.getMasalah(req, res)
})
router.get('/masalah/:idmesin', jwtVerify, function(req, res) {
    RouteToMasalah.getMasalahByMesin(req, res)
})
router.post('/masalah', jwtVerify, function(req, res) {
    RouteToMasalah.addMasalah(req, res, req.decode)
})
router.put('/masalah/:idmasalah', jwtVerify, function(req, res) {
    RouteToMasalah.editMasalah(req, res.send, req.decode)
})

//MESIN
var RouteToMesin = require('../controller/mesin.controller')
router.get('/mesin/:idsite', jwtVerify, function(req, res) {
    RouteToMesin.getMesin(req, res)
})
router.post('/mesin', jwtVerify, function(req, res) {
    RouteToMesin.addMesin(req, res)
})
router.put('/mesin/:idmesin', jwtVerify, function(req, res) {
    RouteToMesin.editMesin(req, res)
})

//PENGGUNA
var RouteToPengguna = require('../controller/pengguna.controller')
router.put('/pengguna', jwtVerify, function(req, res) {
    RouteToPengguna.updateProfile(req, res, req.decode)
})

//PENYELESAIAN
var RouteToPenyelesaian = require('../controller/penyelesaian.controller')
router.get('/penyelesaian', jwtVerify, function(req, res) {
    RouteToPenyelesaian.getPenyelesaian(req, res)
})
router.get('/penyelesaian/:idmasalah', jwtVerify, function(req, res) {
    RouteToPenyelesaian.getPenyelesaianByMasalah(req, res)
})
router.post('/penyelesaian', jwtVerify, function(req, res) {
    RouteToPenyelesaian.addPenyelesaian(req, res, req.decode)
})
router.put('/penyelesaian/:idpenyelesaian', jwtVerify, function(req, res) {
    RouteToPenyelesaian.editPenyelesaian(req, res, req.decode)
})
router.delete('/penyelesaian/:idpenyelesaian', jwtVerify, function(req, res) {
    RouteToPenyelesaian.deletePenyelesaian(req, res)
})

// PROGRESS
var RouteToProgress = require('../controller/progress.controller')
router.post('/progress', jwtVerify, function(req, res) {
    RouteToProgress.addProgress(req, res, req.decode)
})
router.put('/progress/:idprogress', jwtVerify, function(req, res) {
    RouteToProgress.editProgress(req, res, req.decode)
})

//REPORT
var RouteToReport = require('../controller/report.controller')
router.get('/timeline/:idmasalah', jwtVerify, function(req, res) {
    RouteToReport.getTimeline(req, res)
})
router.get('/schedule', jwtVerify, function(req, res) {
    RouteToReport.getSchedule(req, res)
})
router.get('/schedulepart/:idmesin', jwtVerify, function(req, res) {
    RouteToReport.getSchedulePart(req, res)
})
router.get('/stokbarang/:namabarang', jwtVerify, function(req, res) {
    RouteToReport.getLaporanStok(req, res)
})

//SITE
var RouteToSite = require('../controller/site.controller')
router.get('/site', jwtVerify, function(req, res) {
    RouteToSite.getSite(req, res)
})
router.post('/site', jwtVerify, function(req, res) {
    RouteToSite.addSite(req, res)
})
router.put('/site/:idsite', jwtVerify, function(req, res) {
    RouteToSite.editSite(req, res)
})
router.delete('/site/:idsite', jwtVerify, function(req, res) {
    RouteToSite.deleteSite(req, res)
})

module.exports = router;