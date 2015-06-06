# Dependencies
fs= require 'fs'
path= require 'path'

# Private
process.on 'uncaughtException',(error)->
  console.log error.stack

  process.exit module.exports.code 1

# Public
class Result
  constructor: (@logPath)->
    @logPath?= path.resolve __dirname,'..','jasminetea.json'

  get: ->
    try
      log= JSON.parse fs.readFileSync @logPath
    log?= {}

  # Get the exitCode if --cover. via @logPath
  set: (exitCode)->
    log= @get()
    log[process.env.JASMINETEA]?= 0
    log[process.env.JASMINETEA]= 1 if exitCode isnt 0
    logData= JSON.stringify log

    fs.writeFileSync @logPath,logData

    log[process.env.JASMINETEA]

  clear: ->
    fs.writeFileSync @logPath,'{}'

  latest: ->
    latest= null
    latest= exitCode for time,exitCode of @get()
    latest

module.exports= new Result
module.exports.Result= Result