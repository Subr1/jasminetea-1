# Dependencies 
Collection= require './collection'

Promise= require 'bluebird'
globWatcher= require 'glob-watcher'

fs= require 'fs'
path= require 'path'

# Private
resultPath= path.join '..',__dirname,'jasminetea.json'

process.env.JASMINETEA_ID?= Date.now()
process.on 'uncaughtException',(error)->
  console.error error.stack

  try
    result= require resultPath
  finally
    result?= {}
    result[process.env.JASMINETEA_ID]= 1
    resultData= JSON.stringify result

    fs.writeFileSync resultPath,resultData

  process.exit 1

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

    @option '-d --debug','Output raw commands'

  parse: (argv,reporter=null,exec=true)->
    super argv

    reporter?= (string)-> process.stdout.write string
    return @help() if @args.length is 0

    @specDir= @args[0]
    @specs= @getSpecGlobs @specDir,@recursive,@file
    @scripts= @getScriptGlobs 'src',@specDir,@recursive

    @cover= no if '--no-cover' in process.argv
    @watch= @parseGlobs @watch,@scripts if @watch?
    @lint= @parseGlobs @lint,@scripts if @lint?

    return unless exec

    @jasminetea()

    if @watch?
      watcher= globWatcher @watch
      watcher.on 'change',(event)=>
        console.log arguments

        @jasminetea()

  jasminetea: ->
    return if @busy
    @busy= yes

    promises= []
    if @cover
      promises.push @doCover()
      promises.push @doReport() if @report
    else
      promises.push @doRun()
      promises.push @doLint() if @lint

    Promise.all promises
    .then ->
      @busy= no

      result= require resultPath

      process.exit ~~result[process.env.JASMINETEA_ID]

module.exports= new Jasminetea
module.exports.Jasminetea= Jasminetea