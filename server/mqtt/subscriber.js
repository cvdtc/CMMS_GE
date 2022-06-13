const mqtt = require('mqtt')
var client = mqtt.connect('mqtt://localhost:9980')
var topic = 'DataSensor'

client.on('message', (topic, message)=>{
    message = message.toString()
    console.log(message)
})

client.on('connect', ()=>{
    client.subscribe(datasensor)
})
