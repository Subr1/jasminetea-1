# Dependencies
fs= require 'fs'
path= require 'path'

# Environment
logPath= path.resolve __dirname,'..','jasminetea.json'
try
  log= require logPath
catch
  log= {}
finally
  log= {} unless process.env.JASMINETEA

# Private
process.on 'uncaughtException',(error)->
  console.error error.stack

  process.exit result 1

# Public
result= (code)->
  log[process.env.JASMINETEA]?= 0
  log[process.env.JASMINETEA]+= ~~code
  logData= JSON.stringify log

  fs.writeFileSync logPath,logData

  log[process.env.JASMINETEA]

module.exports= result