const mqtt = require('mqtt')
require('dotenv').config()
var pool = require('../utils/pool.configuration')
var client = mqtt.connect('mqtt://localhost:9980')
var topic = 'DataSensor'
var message = 'Hello Syahrul'

client.on('connect', ()=>{
    setInterval(() => {
        client.publish(topic, message)
        
    }, 3000);
})