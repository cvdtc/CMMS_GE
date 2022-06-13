const mosca = require('mosca')
var setting = {port: 9980}
var broker = new mosca.Server(setting)

broker.on('ready', () => {
    console.log('Broker Sudah Siap!')
})

broker.on('published', (packet)=>{
    const message = packet.payload.toString()
    console.log(message)
    // if(message.slice(0,1)!='{'&&message.slice(0,4)!='mqtt'){
        
    // }
})