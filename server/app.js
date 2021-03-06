const express = require('express')
const app = express()
const cors = require('cors')
const router = require('./utils/router')
const docAuth = require('express-basic-auth')
const swaggerUI = require('swagger-ui-express')
const swaggerJS = require('swagger-jsdoc')
const path = require('path')
const morgan = require('morgan')
const fs = require('fs')

/// CREATE MORGAN CONFIGURATION
var writeLogConnection = fs.createWriteStream(path.join(__dirname, 'connectionaccess.log'), { flags: 'a' })
app.use(morgan('combined', { stream: writeLogConnection }))

/// setting up express or api to json type
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(cors())

/// allow image access for public
app.use('/images', express.static(path.join(__dirname, '/images')))

/// url base for api
app.use('/api/v1', router)

/// swagger documentation
const swaggerDOC = {
    definition: {
        openapi: "3.0.3",
        info: {
            title: "Documentation page of api CMMS Grand Elephant",
            version: "1.0.0",
            description: "This is documentation for CMSS apps",
            contact: {
                "email": "info.cvdtc@gmail.com",
                "url": 'cvdtc.com'
            }
        },
        server: [
            {
                url: process.env.DB_HOST,
                description: 'LOCAL'
            }
        ]
    },
    apis: ["./controller/*.js"]
}
const specs = swaggerJS(swaggerDOC)

/// end point swagger documentation
app.use('/secret-docs-api', docAuth({
    users: {
        'admindoc': 'hanyaadmindocyangtau'
    },
    challenge: true
}), swaggerUI.serve, swaggerUI.setup(specs))

/// starting node with port 
app.listen(process.env.API_PORT, () => {
    console.log('Success running api CMMS on ',
        process.env.TYPE_OF_DEPLOYMENT, 'in PORT ',
        process.env.API_PORT, 'Version', process.env.API_VERSION)
})