# Dependencies 
Collection= require './collection'
result= require './result'

Promise= require 'bluebird'
globWatcher= require 'glob-watcher'
chalk= require 'chalk'

path= require 'path'

# Public
class Jasminetea extends Collection
  constructor: ->
    super

    @version require('../package').version
    @usage 'specDir [options...]'

    @option '-c --cover','Use ibrik, Code coverage calculation'
    @option '--report','Use coveralls, Post code coverage to coveralls.io'
    
    @option '-l --lint [globs]','Use coffeelint, Code linting after run. See [globs] (can use "," separator)'

    @option '-w --watch [globs]','Watch file changes. See [globs] (can use "," separator)'
    @option '-f --file [specGlob]','Target [specGlob] (default "*[sS]pec.coffee")'
    @option '-r --recursive','Execute specs in recursive directory'

    @option '-v --verbose','Output spec names'
    @option '-s --stacktrace','Output stack trace'
    @option '-t --timeout <msec>','Success time-limit (default 500 msec)',500
    
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

    if @watch
      watcher= globWatcher @watch
      watcher.on 'change',(event)=>
        name= path.relative process.cwd(),event.path
        @log 'File',@whereabouts(name),event.type

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

      if @watch
        @log 'Watching the',@whereabouts(@watch,' and '),'...'
      else
        process.exit result exitCode

module.exports= new Jasminetea
module.exports.Jasminetea= Jasminetea