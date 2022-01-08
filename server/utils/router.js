require('dotenv').config()
const express = require('express')
const router = express.Router()


// BARANG
var RouteToBarang = require('../controller/barang.controller')
router.get('/barang', function(req, res){
    RouteToBarang.getBarang(req, res)
})

//CHECKOUT
var RouteToCheckout = require('../controller/checkout.controller')
router.get('/checkout/:idmasalah', function(req, res){
    RouteToCheckout.getCheckout(req, res)
})
router.post('/checkout', function(req, res){
    RouteToCheckout.addCheckout(req, res)
})
router.put('/checkout/:idcheckout', function(req, res){
    RouteToCheckout.editCheckout(req, res)
})
router.delete('/checkout/:idcheckout', function(req, res){
    RouteToCheckout.deleteCheckout (req, res)
})


//DASHBOARD
var RouteToDashbord = require('../controller/dashboard.controller')
router.get('/dashboard', function(req, res){
    RouteToDashbord.getDashboard(req, res)
})

//KOMPONEN
var RouteToKomponen = require('../controller/komponen.controller')
router.get('/komponen/:idmesin', function(req, res){
    RouteToKomponen.getKomponen(req, res)
})

//LOGIN
var RouteToLogin = require('../controller/login.controller')
router.post('/login', function(req, res){
    RouteToLogin.Login(req, res)
})
router.get('/cekvalidasi/:token', function(req, res){
    RouteToLogin.cekingToken(req, res)
})
//MASALAH
var RouteToMasalah = require('../controller/masalah.controller')
router.get('/masalah/:flag_activity', function(req, res){
    RouteToMasalah.getMasalah(req, res)
})
router.get('/masalah/:idmesin', function(req, res){
    RouteToMasalah.getMasalahByMesin(req, res)
})
router.post('/masalah', function(req, res){
    RouteToMasalah.addMasalah(req, res)
})
router.put('/masalah/:idmasalah', function(req, res){
    RouteToMasalah.editMasalah(req, res)
})

//MESIN
var RouteToMesin = require('../controller/mesin.controller')
router.get('/mesin/:idsite', function(req, res){
    RouteToMesin.getMesin(req, res)
})
router.post('/mesin', function(req, res){
    RouteToMesin.addMesin(req, res)
})
router.put('/mesin/:idmesin', function(req, res){
    RouteToMesin.editMesin(req, res)
})

//PENYELESAIAN
var RouteToPenyelesaian = require('../controller/penyelesaian.controller')
router.get('/penyelesaian', function(req, res){
    RouteToPenyelesaian.getPenyelesaian(req, res)
})
router.get('/penyelesaian/:idmasalah', function(req, res){
    RouteToPenyelesaian.getPenyelesaianByMasalah(req, res)
})
router.post('/penyelesaian', function(req, res){
    RouteToPenyelesaian.addPenyelesaian(req, res)
})
router.put('/penyelesaian/:idpenyelesaian', function(req, res){
    RouteToPenyelesaian.editPenyelesaian(req, res)
})
router.put('/penyelesaian/:idpenyelesaian', function(req, res){
    RouteToPenyelesaian.deletePenyelesaian(req, res)
})

// PROGRESS
var RouteToProgress = require('../controller/progress.controller')
router.post('/progress', function(req, res){
    RouteToProgress.addProgress(req, res)
})
router.put('/progress/:idprogress', function(req, res){
    RouteToProgress.editProgress(req, res)
})

var RouteToReport = require('../controller/report.controller')
router.get('/timeline/:idmasalah', function(req, res){
    RouteToReport.getTimeline(req, res)
})

//SITE
var RouteToSite = require('../controller/site.controller')
router.get('/site', function(req, res){
    RouteToSite.getSite(req, res)
})
router.post('/site', function(req, res){
    RouteToSite.addSite(req, res)
})
router.put('/site/:idsite', function(req, res){
    RouteToSite.editSite(req, res)
})
router.delete('/site/:idsite', function(req, res){
    RouteToSite.deleteSite(req, res)
})

module.exports = router;