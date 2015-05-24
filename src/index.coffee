# Dependencies 
Collection= require './collection'

Promise= require 'bluebird'
globWatcher= require 'glob-watcher'
chalk= require 'chalk'

fs= require 'fs'
path= require 'path'

# Private
process.on 'uncaughtException',(error)->
  console.error error.stack

  process.exit result 1

logPath= path.resolve __dirname,'..','jasminetea.json'
try
  log= require logPath
catch
  log= {}
finally
  log= {} unless process.env.JASMINETEA

result= (code)->
  log[process.env.JASMINETEA]?= 0
  log[process.env.JASMINETEA]+= ~~code
  logData= JSON.stringify log
  fs.writeFileSync logPath,logData

  log[process.env.JASMINETEA]

# Public
class Jasminetea extends Collection
  constructor: ->
    super

    @version require('../package').version
    @usage 'specDir [options..]'

    @option '-w --watch [globs]','Watch file changes. See [globs] (can use "," separator)'
    @option '-f --file [specGlob]','Target [specGlob] (default "*[sS]pec.coffee")'
    @option '-r --recursive','Execute specs in recursive directory'

    @option '-v --verbose','Output spec names'
    @option '-s --stacktrace','Output stack trace'
    @option '-t --timeout <msec>','Success time-limit (default 500 msec)',500

    @option '-l --lint [globs]','Use coffeelint, Code linting after run. See [globs] (can use "," separator)'

    @option '-c --cover','Use ibrik, Code coverage calculation'
    @option '--report','Use coveralls, Post code coverage to coveralls.io'

    @option '-d --debug','Output raw commands',yes

  parse: (argv)->
    super argv

    return @help() if @args.length is 0

    @specDir= @args[0]
    @specs= @getSpecGlobs @specDir,@recursive,@file
    @scripts= @getScriptGlobs 'src',@specDir,@recursive

    @watch= @parseGlobs @watch,@scripts if @watch?
    @lint= @parseGlobs @lint,@scripts if @lint?

    if process.env.JASMINETEA
      @watch= no
      @lint= no
      @cover= no
      @report= no
    else
      process.env.JASMINETEA?= Date.now()

    return if @noExecution

    @jasminetea()
    if @watch?
      watcher= globWatcher @watch
      watcher.on 'change',(event)=>
        name= chalk.underline path.relative process.cwd(),event.path
        @log 'File',name,event.type

        @jasminetea()

  jasminetea: ->
    return if @busy

    @busy= yes
    exitCode= 0

    promise= if @cover then @doCover() else @doRun()
    promise
    .then (code)=>
      exitCode= 1 if code
      @doReport() if @report

    .then (code)=>
      exitCode= 1 if code
      @doLint() if @lint

    .then (code)=>
      exitCode= 1 if code

      @busy= no

      process.exit result exitCode unless @watch

module.exports= new Jasminetea
module.exports.Jasminetea= Jasminetea