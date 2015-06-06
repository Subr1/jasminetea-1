# Dependencies
Collection= (require './collection').Collection
result= require './result'

Promise= require 'bluebird'
gaze= require 'gaze'
chalk= require 'chalk'

path= require 'path'

# Public
class Jasminetea extends Collection
  # Setup commander.js
  constructor: ->
    super

    @version require('../package').version
    @usage '[specDir] [options...]'

    @option '-c --cover',
      'Use ibrik, Code coverage calculation'
    @option '--report',
      'Send lcov.info to coveralls.io via --cover'
    @option '-l --lint [globs]',
      'Use .coffeelintrc, Code linting after run. Find in [globs] (can use "," separator)'

    @option '-w --watch [globs]',
      'Watch file changes. See [globs] (can use "," separator)'
    @option '-f --file [specGlob]',
      'Target [specGlob] (default "*[sS]pec.coffee")','*[sS]pec.coffee'
    @option '-r --recursive',
      'Search to recursive directory'

    @option '-S --silent',
      'Use dots reporter',false
    @option '-s --stacktrace',
      'Output stack trace'
    @option '-t --timeout <msec>',
      'Success time-limit (default 500 msec)',500
    
    @option '-d --debug',
      'Output raw commands',yes

  parse: (argv)->
    super argv

    @specDir= @args[0]
    @specDir?= 'test'
    @specs= @getSpecGlobs @specDir,@file,@recursive
    @scripts= @getScriptGlobs 'src',@specDir,@recursive

    @watch= @parseGlobs @watch,@scripts if @watch?
    @lint= @parseGlobs @lint,@scripts if @lint?

    cover= process.env.JASMINETEA
    if cover
      @cover= no
      @report= no
      @lint= no
      @watch= no
    else
      process.env.JASMINETEA?= Date.now()

    return if @test

    @jasminetea()

    if @watch
      gaze @watch,(error,watcher)=>
        console.error error if error?

        watcher.on 'all',(event,filepath)=>
          name= path.relative process.cwd(),filepath
          @log 'File',@whereabouts(name),event

          @jasminetea()

  # Process life cycle
  jasminetea: ->
    return if @busy
    @busy= yes

    options=
      silent: @silent
      stacktrace: @stacktrace
      timeout: @timeout

    exitCode= 0
    promise= if @cover then @doCover() else @doRun @specs,options
    promise
    .then (code)=>
      exitCode= 1 if code
      @doReport() if @report

    .then (code)=>
      exitCode= 1 if code
      @doLint @lint if @lint

    .then (code)=>
      exitCode= 1 if code
      @busy= no

      if @watch
        @log 'Watch in',@whereabouts(@watch,' and '),'...'
      else
        process.exit result.code exitCode

module.exports= new Jasminetea
module.exports.Jasminetea= Jasminetea