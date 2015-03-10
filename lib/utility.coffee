class Utility
  logColors: ['magenta','cyan','green','yellow']
  logBgColors: ['bgMagenta','bgCyan','bgGreen','bgYellow']

  constructor: ->
    @i= 0

  h1: (args...)->
    console.log ''
    console.log chalk.bold args...
  log: (args...)->
    [...,changeColor]= args
    args= args[...-1] if changeColor is yes

    console.log '7_P',@getColor(changeColor) args...
  getColor: (changeColor=no)->
    @i= 0 if @logColors[@i] is undefined
    color= chalk[@logColors[@i]]
    @i++ if changeColor is yes

    color
  getBgColor: (changeColor=no)->
    @i= 0 if @logBgColors[@i] is undefined
    color= chalk[@logBgColors[@i]]
    @i++ if changeColor is yes

    color

  noop: ()->
    noop= new EventEmitter
    process.nextTick -> noop.emit 'close'
    noop

  getSpecGlobs: (specDir,recursive=null)->
    specDir= path.join specDir,'**' if recursive?

    globs= []
    globs.push path.join specDir,'*[sS]pec.coffee'
    globs

  getScriptGlobs: (libDir,specDir,recursive=null)->
    cwd= '.' if specDir isnt '.'
    libDir= path.join(libDir,'**') if recursive?
    specDir= path.join(specDir,'**') if recursive?

    globs= []
    globs.push path.join(cwd,'*.coffee') if cwd?
    globs.push path.join libDir,'*.coffee'
    globs.push path.join specDir,'*.coffee'
    globs

path= require 'path'
EventEmitter= require('events').EventEmitter

chalk= require 'chalk'

module.exports= Utility