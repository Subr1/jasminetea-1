class Jasminetea extends require './collection'
  config:# for protractor conf.js
    seleniumKillAddress:
      'http://localhost:4444/selenium-server/driver/?cmd=shutDownSeleniumServer'

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
      isVerbose:
        process.env.JASMINETEA_VERBOSE
      defaultTimeoutInterval:
        process.env.JASMINETEA_TIMEOUT
      includeStackTrace:
        process.env.JASMINETEA_STACKTRACE

  cli:->
    cli= require 'commander'
    cli
      .version require('../package').version
      .description chalk.magenta('7')+chalk.yellow('_')+chalk.green('P')
      .usage 'specDir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-v --verbose','Output spec names'
      .option '-s --stacktrace','Output stack trace'
      .option '-t --timeout <msec>','Success time-limit <1000>msec',1000

      .option '-f --file [specGlob]','Target [specGlob]'
      .option '-w --watch [globs]','Watch file changes. Refer [globs] (can use "," separator)'

      .option '-c --cover','Use ibrik, Code coverage calculation'
      .option '--report','Use coveralls, Reporting code coverage to coveralls.io'
      .option '-l --lint [globs]','Use coffeelint, Code linting after run. Refer [globs] (can use "," separator)'
      .option '-e --e2e [==param ...]','Use protractor, Change to the E2E test mode'

      .option '-d --debug','Output raw commands and stdout $ for -c,-l,-e'

      .parse process.argv
    cli.help() if cli.args[0] is undefined

    specDir= cli.args[0]
    specs= @getSpecGlobs specDir,cli.recursive,cli.file
    scripts= @getScriptGlobs 'lib',specDir,cli.recursive

    cli.watch= scripts if cli.watch is yes
    cli.watch= cli.watch.split(',') if typeof cli.watch is 'string'

    cli.lint= scripts if cli.lint is yes
    cli.lint= cli.lint.split(',') if typeof cli.lint is 'string'

    cli.cover= no if '-C' in process.argv

    process.env.JASMINETEA_ID?= Date.now()
    process.env.JASMINETEA_MODE= 'SERVER'
    process.env.JASMINETEA_MODE= 'CLIENT' if cli.e2e?

    resultFile= path.join __dirname,'..','jasminetea.json'
    fs.writeFileSync resultFile,'{}' if not ('-C' in process.argv)

    test= @run
    test= @cover if cli.cover is yes
    test.call(this,specs,cli).once 'close',(code,seleniumManager=0)=>
      lint= @noop
      lint= @lint if cli.lint? and not ('-C' in process.argv)
      lint.call(this,cli).once 'close',=>
        return @watch cli if cli.watch? and not ('-C' in process.argv)

        kill= @noop
        kill= @webdriverKill if seleniumManager isnt 0
        kill(seleniumManager,@config.seleniumKillAddress).once 'close',=>
          report= @noop
          report= @report if cli.cover is yes and cli.report?
          report.call(this,cli).once 'close',=>
            @log 'Calculating...' if '-C' in process.argv

            result= {}
            result= require resultFile if fs.existsSync resultFile
            result[process.env.JASMINETEA_ID]= 1 if code is 1
            fs.writeFileSync resultFile,JSON.stringify result

            process.exit ~~result[process.env.JASMINETEA_ID]

  run: (specs,options={})->
    files= require('wanderer').seekSync specs

    @log chalk.bold "E2E test mode" if options.e2e?

    target= (chalk.underline(glob) for glob in specs).join(' or ')
    @log "Found #{files.length} files by",target,'...' if files.length
    if files.length is 0
      @log "Spec Notfound. by",(chalk.underline(path.resolve spec) for spec in specs).join(' or ')
      process.exit 1 if options.watch is undefined

    runner= null
    runner= @runJasmine specs,options if options.e2e is undefined
    runner= @runProtractor specs,options if options.e2e?
    runner

  watch: (options={})->
    manager= new EventEmitter

    target= (chalk.underline(glob) for glob in options.watch).join(' or ')
    @log 'Watching files by',target,'...'

    watcher= require('chokidar').watch options.watch,persistent:true,ignoreInitial:true
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

fs= require 'fs'
path= require 'path'
EventEmitter= require('events').EventEmitter

chalk= require 'chalk'

module.exports= Jasminetea