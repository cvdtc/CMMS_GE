require('dotenv').config()
const express = require('express')
const router = express.Router()

//DASHBOARD
var RouteToDashbord = require('../controller/dashboard.controller')
router.get('/dashboard', function(req, res){
    RouteToDashbord.getDashboard(req, res)
})

//LOGIN
var RouteToLogin = require('../controller/login.controller')
router.post('/login', function(req, res){
    RouteToLogin.Login(req, res)
})

//MASALAH
var RouteToMasalah = require('../controller/masalah.controller')
router.get('/masalah', function(req, res){
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
router.get('/mesin', function(req, res){
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

module.exports = router;