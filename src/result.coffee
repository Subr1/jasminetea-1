# Dependencies
fs= require 'fs'
path= require 'path'

# Environment
logPath= path.resolve __dirname,'..','jasminetea.json'

# Private
process.on 'uncaughtException',(error)->
  console.error error.stack

  process.exit result 1

# Public
result= (code)->
  try
    log= JSON.parse fs.readFileSync logPath
  log?= {}
  log[process.env.JASMINETEA]?= 0
  log[process.env.JASMINETEA]+= ~~code
  logData= JSON.stringify log

  fs.writeFileSync logPath,logData

  log[process.env.JASMINETEA]

module.exports= result