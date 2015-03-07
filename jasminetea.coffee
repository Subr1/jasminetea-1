jasminetea=
  cli:->
    cli
      .version require('./package').version
      .description chalk.magenta('~')+chalk.cyan(' 7')+chalk.green('_')+chalk.yellow('P')
      .usage 'specDir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'

      .option '-v --verbose','Output spec names'
      .option '-s --stacktrace','Output stack trace'
      .option '-t --timeout <msec>','Success time-limit <500>msec',500

      .option '-w --watch [globs]','Watch file changes. Refer [globs] (can use "," separator)'
      .option '-c --cover','Use ibrik, Code coverage calculation'
      .option '-l --lint [globs]','Use coffeelint, Code linting after run. Refer [globs] (can use "," separator)'
    
      .option '-p --protractor [==arg]','Use protractor, Change to the E2E test mode'
      .option '-d --debug','Output raw commands $ for -c,-l,-e,-p'

      .parse process.argv
    cli.help() if cli.args[0] is undefined

    @specDir= cli.args[0]
    @specs= @getSpecGlobs @specDir,cli.recursive
    @scripts= @getScriptGlobs 'lib',@specDir,cli.recursive

    cli.watch= @scripts if cli.watch is yes
    cli.watch= cli.watch.split(',') if typeof cli.watch is 'string'

    cli.lint= @scripts if cli.lint is yes
    cli.lint= cli.lint.split(',') if typeof cli.lint is 'string'

    cli.cover= no if '-C' in process.argv

    process.env.JASMINETEA_MODE= 'SERVER'
    process.env.JASMINETEA_MODE= 'CLIENT' if cli.protractor?

    test= @run
    test= @cover if cli.cover is yes
    test.call(this,cli).once 'close',(seleniumManager=0)=>
      lint= @noop
      lint= @lint if cli.lint? and not ('-C' in process.argv)
      lint.call(this,cli).once 'close',=>
        return @watch cli if cli.watch? and not ('-C' in process.argv)

        kill= @noop
        kill= @webdriverKill if seleniumManager isnt 0
        kill(seleniumManager,@config.seleniumKillAddress).once 'close',->
          process.exit 0

  ###
    Core options
  ###

  run: (cli)->
    files= wanderer.seekSync @specs

    @log chalk.bold "Protractor mode" if cli.protractor?

    target= (chalk.underline(glob) for glob in @specs).join(' or ')
    @log "Found #{files.length} files by",target,'...' if files.length
    if files.length is 0
      @log "Spec Notfound. by",(chalk.underline(path.resolve spec) for spec in @specs).join(' or ')
      #process.exit 1

    runner= null
    runner= @runJasmine cli if cli.protractor is undefined
    runner= @runProtractor cli if cli.protractor?
    runner

  runJasmine: (cli)->
    runner= new events.EventEmitter

    jasmine= new Jasmine
    jasmine.addReporter new Reporter
      showColors: true
      isVerbose: cli.verbose
      includeStackTrace: cli.stacktrace
    jasmine.jasmine.DEFAULT_TIMEOUT_INTERVAL= cli.timeout

    wanderer.seek @specs
      .on 'data',(file)->
        filename= path.resolve process.cwd(),file

        jasminetea.deleteRequireCache require.resolve filename
        jasmine.addSpecFile filename
      .once 'end',->
        try
          jasmine.execute()
        catch error
          console.error error?.stack?.toString() ? error?.message ? error

    jasmine.addReporter
      jasmineDone: ->
        runner.emit 'close'

    runner

  runProtractor: (cli)->
    runner= new events.EventEmitter

    @webdriverUpdate(cli).once 'close',=>
      manager= @webdriverStart cli
      manager.once 'start',=>
        protractor= @protractor cli
        protractor.stdout.on 'data',(buffer)->
          process.stdout.write buffer.toString()
        protractor.stderr.on 'data',(buffer)->
          process.stderr.write buffer.toString()
        protractor.on 'error',(stack)->
          console.error error?.stack?.toString() ? error?.message ? error
          runner.emit 'close',manager
        protractor.once 'close',->
          runner.emit 'close',manager

    runner

  protractor: (cli)->
    args= []
    args.push 'node'
    args.push require.resolve 'protractor/bin/protractor'
    args.push require.resolve './jasminetea.coffee' # module.exprots.config
    args.push cli.protractor.replace(new RegExp('==','g'),'--').split(/¥s/) if typeof cli.protractor is 'string'
    args.push '--specs'
    args.push wanderer.seekSync(@specs).join ','
    
    # @log 'Arguments has been ignored',(chalk.underline(arg) for arg in cli.args[1...]).join ' '
    @log '$',args.join ' ' if cli.debug?

    process.env.JASMINETEA_VERBOSE= cli.verbose
    process.env.JASMINETEA_TIMEOUT= cli.timeout
    process.env.JASMINETEA_STACKTRACE= cli.stacktrace

    [script,args...]= args
    childProcess.spawn script,args,env:process.env

  config:
    seleniumKillAddress: 'http://localhost:4444/selenium-server/driver/?cmd=shutDownSeleniumServer'
    jasmineNodeOpts:
      showColors: true
      isVerbose: process.env.JASMINETEA_VERBOSE
      defaultTimeoutInterval: process.env.JASMINETEA_TIMEOUT
      includeStackTrace: process.env.JASMINETEA_STACKTRACE
    capabilities:
      browserName: 'chrome'
      # for Travis User (by Sauce Labs)
      'tunnel-identifier': process.env.TRAVIS_JOB_NUMBER
    sauceUser: process.env.SAUCE_USERNAME
    sauceKey: process.env.SAUCE_ACCESS_KEY

  webdriverUpdate: (cli)->
    args= []
    args.push 'node'
    args.push require.resolve 'protractor/bin/webdriver-manager'
    args.push 'update'
    args.push '--standalone'
    @log '$',args.join ' ' if cli.debug?

    [script,args...]= args
    childProcess.spawn script,args,stdio:'inherit'

  webdriverStart: (cli)->
    manager= new events.EventEmitter
    if process.env.JASMINETEA_SELENIUM
      process.nextTick -> manager.emit 'start'
      return manager

    args= []
    args.push 'node'
    args.push require.resolve 'protractor/bin/webdriver-manager'
    args.push 'start'
    @log '$',args.join ' ' if cli.debug?

    [script,args...]= args
    selenium= childProcess.spawn script,args,env:process.env
    selenium.stderr.on 'data',(buffer)->
      manager.emit 'data','stderr',buffer
    selenium.stdout.on 'data',(buffer)->
      manager.emit 'data','stdout',buffer
    manager.on 'data',(type,buffer)->
      return if not buffer.toString().match /(Started SocketListener|Selenium Standalone has exited)/g
      return if process.env.JASMINETEA_SELENIUM

      process.env.JASMINETEA_SELENIUM= on
      manager.emit 'start',selenium

    selenium.once 'close',->
      manager.emit 'close'

    manager

  webdriverKill: (seleniumManager,url)->
    http.get url # todo exchange kill signal
    seleniumManager

  deleteRequireCache: (id)->
    return if id.indexOf('node_modules') > -1

    files= require.cache[id]
    if files?
      jasminetea.deleteRequireCache file.id for file in files.children
      delete require.cache[id]

  cover: (cli)->
    try
      # Fix conflict coffee-script/registeer 1.8.0
      conflicted= require.resolve 'ibrik/node_modules/coffee-script'
      rimraf.sync path.resolve conflicted,'../../../'

    catch noConflict
      # Fixed

    args= []
    args.push require.resolve 'ibrik/bin/ibrik'
    args.push 'cover'
    args.push require.resolve './jasminetea'
    args.push '--'
    args= args.concat process.argv[2...]
    args.push '-C'
    args.push '&&'
    args.push require.resolve 'istanbul/lib/cli.js'
    args.push 'report'
    args.push 'html'
    @log '$',args.join ' ' if cli.debug?

    childProcess.spawn 'node',args,{stdio:'inherit',cwd:process.cwd()}

  watch: (cli)->
    manager= new events.EventEmitter

    target= (chalk.underline(glob) for glob in cli.watch).join(' or ')
    @log 'Watching files by',target,'...'

    watcher= chokidar.watch cli.watch,persistent:true,ignoreInitial:true
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
      test= @cover if cli.cover is yes
      test.call(this,cli).once 'close',=>
        lint= @noop
        lint= @lint if cli.lint? and not ('-C' in process.argv)
        lint.call(this,cli).once 'close',=>
          manager.busy= null

          console.log ''
          @log 'Watching files by',target,'...'

    manager

  lint: (cli)->
    args= [require.resolve 'coffeelint/bin/coffeelint']
    args.push path.relative process.cwd(),file for file in wanderer.seekSync cli.lint
    @log '$',args.join ' ' if cli.debug?

    console.log ''
    @log 'Lint by',cli.lint.join(' or '),'...'
    childProcess.spawn 'node',args,{stdio:'inherit',cwd:process.cwd()}

  noop: ()->
    noop= new events.EventEmitter
    process.nextTick -> noop.emit 'close'
    noop

  ###
    common
  ###

  getSpecGlobs: (specDir,recursive=null)->
    specDir= path.join specDir,'**' if recursive?

    globs= []
    globs.push path.join specDir,'*[sS]pec.js'
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

  logColors: ['magenta','cyan','green','yellow']
  logBgColors: ['bgMagenta','bgCyan','bgGreen','bgYellow']

  h1: (args...)->
    console.log ''
    console.log chalk.bold args...
  log: (args...)->
    [...,changeColor]= args
    args= args[...-1] if changeColor is yes

    console.log '~ 7_P',@getColor(changeColor) args...
  getColor: (changeColor=no)->
    @log.i= 0 if @logColors[@log.i] is undefined
    color= chalk[@logColors[@log.i]]
    @log.i++ if changeColor is yes

    color
  getBgColor: (changeColor=no)->
    @log.i= 0 if @logBgColors[@log.i] is undefined
    color= chalk[@logBgColors[@log.i]]
    @log.i++ if changeColor is yes

    color

{
  path,childProcess,events,http

  chalk
  cli,wanderer
  Jasmine,Reporter
  chokidar
  rimraf
}= require('node-module-all')
  builtinLibs: true

  change: 'camelCase'
  rename:
    commander: 'cli'
    jasmine: 'Jasmine'
    'jasmine-terminal-reporter': 'Reporter'

module.exports= jasminetea