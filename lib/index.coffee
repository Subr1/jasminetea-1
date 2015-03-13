cli= require 'commander'
wanderer= require 'wanderer'
rimraf= require 'rimraf'
chokidar= require 'chokidar'

fs= require 'fs'
path= require 'path'
EventEmitter= require('events').EventEmitter

chalk= require 'chalk'

class Jasminetea extends require './collection'
  cli:->
    cli
      .version require('../package').version
      .description chalk.magenta('7')+chalk.yellow('_')+chalk.green('P')
      .usage 'specDir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-v --verbose','Output spec names'
      .option '-s --stacktrace','Output stack trace'
      .option '-t --timeout <msec>','Success time-limit (default 1000 msec)',1000

      .option '-f --file [specGlob]','Target [specGlob] (default "*[sS]pec.coffee")'
      .option '-w --watch [globs]','Watch file changes. See [globs] (can use "," separator)'

      .option '-c --cover','Use ibrik, Code coverage calculation'
      .option '--report','Use coveralls, Reporting code coverage to coveralls.io'
      .option '-l --lint [globs]','Use coffeelint, Code linting after run. See [globs] (can use "," separator)'
      .option '-e --e2e [==param ...]','Use protractor, Change to the E2E test mode'

      .option '-d --debug','Output raw commands and stdout $ for --cover,--lint,--e2e'

      .parse process.argv
    cli.help() if cli.args[0] is undefined

    options= cli

    specDir= options.args[0]
    specs= @getSpecGlobs specDir,options.recursive,options.file
    scripts= @getScriptGlobs 'lib',specDir,options.recursive

    options.watch= scripts if options.watch is yes
    options.watch= options.watch.split(',') if typeof options.watch is 'string'

    options.lint= scripts if options.lint is yes
    options.lint= options.lint.split(',') if typeof options.lint is 'string'

    options.cover= no if '-C' in process.argv

    process.env.JASMINETEA_ID?= Date.now()
    process.env.JASMINETEA_MODE= 'SERVER'
    process.env.JASMINETEA_MODE= 'CLIENT' if options.e2e?

    resultFile= path.join __dirname,'..','jasminetea.json'
    fs.writeFileSync resultFile,'{}' if not ('-C' in process.argv)

    @run(specs,options).once 'close',(code,seleniumManager=0)=>
      lint= @noop
      lint= @lint if options.lint? and not ('-C' in process.argv)
      lint.call(this,options).once 'close',=>
        return @watch options if options.watch? and not ('-C' in process.argv)

        report= @noop
        report= @report if options.cover is yes and options.report?
        report.call(this,options).once 'close',=>
          @log 'Calculating...' if '-C' in process.argv

          result= {}
          result= require resultFile if fs.existsSync resultFile
          result[process.env.JASMINETEA_ID]= 1 if code is 1
          fs.writeFileSync resultFile,JSON.stringify result

          process.exit ~~result[process.env.JASMINETEA_ID]

  run: (specs,options={})->
    files= wanderer.seekSync specs

    @log chalk.bold "E2E test mode" if options.e2e?

    target= (chalk.underline(glob) for glob in specs).join(' or ')
    @log "Found #{files.length} files by",target,'...' if files.length
    if files.length is 0
      @log "Spec Notfound. by",(chalk.underline(path.resolve spec) for spec in specs).join(' or ')
      process.exit 1 if options.watch is undefined

    # Protractor additional config (See jasminetea.config)
    process.env.JASMINETEA_VERBOSE= options.verbose
    process.env.JASMINETEA_TIMEOUT= options.timeout
    process.env.JASMINETEA_STACKTRACE= options.stacktrace

    runner= null
    if options.cover is yes
      runner= @cover specs,options
    else
      runner= @runJasmine specs,options if options.e2e is undefined
      runner= @runProtractor specs,options if options.e2e?
    runner

  cover: (specs,options={})->
    try
      # Fix conflict coffee-script/registeer 1.8.0
      rimraf.sync path.join process.cwd(),'coverage'
      rimraf.sync path.dirname require.resolve 'ibrik/node_modules/coffee-script/register'

    catch noConflict
      # Fixed

    return @coverJasmine specs,options if options.e2e is undefined
    return @coverProtractor specs,options if options.e2e?

  watch: (options={})->
    manager= new EventEmitter

    target= (chalk.underline(glob) for glob in options.watch).join(' or ')
    @log 'Watching files by',target,'...'

    watcher= chokidar.watch options.watch,persistent:true,ignoreInitial:true
    watcher.on 'change',(path)=>
      return if manager.busy?

      @log 'File',chalk.underline(path),'has been changed.',true
      manager.emit 'restart'

    watcher.on 'unlink', (path)=>
      return if manager.busy?

      @log 'File',chalk.underline(path),'has been removed.',true
      manager.emit 'restart'

    manager.on 'restart',=>
      manager.busy= true

      test= @run
      test= @cover if options.cover is yes
      test.call(this,options).once 'close',=>
        lint= @noop
        lint= @lint if options.lint? and not ('-C' in process.argv)
        lint.call(this,options).once 'close',=>
          manager.busy= null

          console.log ''
          @log 'Watching files by',target,'...'

    manager

  config:# for protractor conf.js(Use collection/protractor,coverProtractor)
    capabilities:
      browserName: 'chrome'
      # for Travis User (by Sauce Labs)
      'tunnel-identifier':
        process.env.TRAVIS_JOB_NUMBER

    sauceUser:
      process.env.SAUCE_USERNAME
    sauceKey:
      process.env.SAUCE_ACCESS_KEY

    jasmineNodeOpts:
      showColors: true

# Via Jasminetea.run for Protractor conf.js
jasmineNodeOpts= Jasminetea::config.jasmineNodeOpts
jasmineNodeOpts.isVerbose= true if process.env.JASMINETEA_VERBOSE isnt 'undefined' 
jasmineNodeOpts.defaultTimeoutInterval= process.env.JASMINETEA_TIMEOUT
jasmineNodeOpts.includeStackTrace= process.env.JASMINETEA_STACKTRACE

module.exports= Jasminetea