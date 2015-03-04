jasminetea=
  cli:->
    cli
      .version require('./package').version
      .usage 'specDir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'

      .option '-w --watch [globs]','Watch file changes. Refer [globs] (can use "," separator)'
      .option '-c --cover','Use ibrik, Code coverage calculation'
      .option '-l --lint [globs]','Use coffeelint, Code linting after run. Refer [globs] (can use "," separator)'
    
      .option '-v --verbose','Output spec names'
      .option '-t --timeout <msec>','Success time-limit <500>msec',500
      .option '-s --stacktrace','Output stack trace'

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

    test= @run
    test= @cover if cli.cover is yes
    test.call(this,cli).once 'close',()=>
      lint= @noop
      lint= @lint if cli.lint? and not ('-C' in process.argv)
      lint.call(this,cli).on 'close',=>
        return @watch cli if cli.watch? and not ('-C' in process.argv)

        process.exit 0

  ###
    Core options
  ###

  run: (cli)->
    runner= new events.EventEmitter

    files= wanderer.seekSync @specs

    target= (chalk.underline(glob) for glob in @specs).join(' or ')
    @log "Found #{files.length} files by",target,'...' if files.length
    @log "Notfound by",(chalk.underline(path.resolve spec) for spec in @specs).join(' or ') if files.length is 0

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
      .on 'end',->
        try
          jasmine.execute()
        catch error
          console.error error?.stack?.toString() ? error?.message ? error

    jasmine.addReporter
      jasmineDone: ->
        runner.emit 'close'

    runner

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

    childProcess.spawn 'node',args,stdio:'inherit',cwd:process.cwd()

  watch: (cli)->
    manager= new events.EventEmitter

    target= (chalk.underline(glob) for glob in cli.watch).join(' or ')
    @log 'Watching files by',target,'...'

    watcher= chokidar.watch cli.watch,persistent:true,ignoreInitial:true
    watcher.on 'change',(path)=>
      return if manager.busy?

      @logColorChange()
      @log 'File',chalk.underline(path),'has been changed.'
      manager.emit 'restart'

    watcher.on 'unlink', (path)=>
      return if manager.busy?

      @logColorChange()
      @log 'File',chalk.underline(path),'has been removed.'
      manager.emit 'restart'

    manager.on 'restart',=>
      manager.busy= true

      test= @run
      test= @cover if cli.cover is yes
      test.call(this,cli).once 'close',=>
        lint= @noop
        lint= @lint if cli.lint? and not ('-C' in process.argv)
        lint.call(this,cli).on 'close',=>
          manager.busy= null

          console.log ''
          @log 'Watching files by',target,'...'

    manager

  lint: (cli)->
    args= [require.resolve 'coffeelint/bin/coffeelint']
    args.push path.relative process.cwd(),file for file in wanderer.seekSync cli.lint

    @log ''
    @log 'Lint by',cli.lint.join(' or '),'...'
    childProcess.spawn 'node',args,stdio:'inherit',cwd:process.cwd()

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

  log: (args...)->
    @log.i= 0 if @logColors[@log.i] is undefined
    console.log chalk[@logColors[@log.i]] args...
    # growl args.join(' '),image:'.svg'
  logColors: ['green','magenta','cyan']
  logColorChange: ->
    @log.i++
    @logColors[@log.i]

{
  path,childProcess,events

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