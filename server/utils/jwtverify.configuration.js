require('dotenv').config()
const jwt = require('jsonwebtoken')

async function jwtVerify(req, res, next) {
    const token = req.headers.authorization
    if (!token) {
        console.log('no token')
        return res.status(401).send({
            message: 'Sorry 😞, We need token to authorization.',
            error: null,
            data: null
        })
    }
    try {
        const decode = jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET)
        req.decode = decode
        /// checking api version and app version
        if (decode.appversion < process.env.API_VERSION) {
            return res.status(401).send({
                message: 'Sorry 😞, Invalid Version, please update.',
                error: null,
                data: null
            })
        } else {
            next()
        }
    } catch (error) {
        return res.status(401).send({
            message: 'Sorry 😞, Invalid Token.',
            error: null,
            data: null
        })
    }
}

module.exports = jwtVerify