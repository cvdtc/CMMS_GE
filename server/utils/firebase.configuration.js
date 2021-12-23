var fcmadmin = require('firebase-admin')
var serverKey = require('./cmmsge.firebasetoken.json')
fcmadmin.initializeApp({
    credential: fcmadmin.credential.cert(serverKey)
})
module.exports = fcmadmin