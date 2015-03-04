jasminetea=
  cli:->
    cli
      .version require('./package').version
      .usage 'specDir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-w --watch [globs]','Watch file changes. Refer [globs] (can use "," separator)'
      .option '-c --cover','Use ibrik, Code coverage calculation'
    
      .option '-v --verbose','Output spec names'
      .option '-t --timeout <msec>','Success time-limit <500>msec',500
      .option '-s --stacktrace','Output stack trace'

      .option '-l --lint [globs]','Use coffeelint, Code linting after success. Refer [globs] (can use "," separator)'
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
    return @cover(cli) if cli.cover is yes

    @log "Found #{gulpSrcFiles(@specs).length} files by",@specs.join(' or '),'...'
    @run(cli).on 'end',()-> process.exit 0

  ###
    Core options
  ###

  run: (cli,firstRun=true)->
    event= new events.EventEmitter

    gulp.src @specs
      .pipe jasmine
        verbose: cli.verbose
        timeout: cli.timeout
        includeStackTrace: cli.stacktrace
      .on 'data',-> null
      .on 'error',(error)=>
        console.error error.stack?.toString() ? error
        @watch cli if cli.watch && firstRun is yes
      .on 'end',=>
        lint= @noop
        lint= @lint if cli.lint?
        lint.call(this,cli).on 'close',=>
          return @watch cli if cli.watch && firstRun is yes

          event.emit 'end'

    event

  watch: (cli)->
    @log 'Wathing files by',cli.watch.join(' or '),'...'
    watch cli.watch,=>
      @logColorChange()
      @log 'File was changed by',cli.watch.join(' or ')
      @run cli,false

  noop: ()->
    noop= new events.EventEmitter
    process.nextTick -> noop.emit 'close'
    noop

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

    child_process.spawn 'node',args,stdio:'inherit',cwd:process.cwd()

  lint: (cli)->
    args= [require.resolve 'coffeelint/bin/coffeelint']
    args.push path.relative process.cwd(),file for file in gulpSrcFiles cli.lint

    @log ''
    @log 'Next, linting by',cli.lint.join(' or '),'...'
    spawned= child_process.spawn 'node',args,stdio:'inherit',cwd:process.cwd()
    spawned.on 'close',=>
      @log 'Linted from',cli.lint.join(' or ')
    spawned

  ###
    common
  ###

  log: ->
    @log.i= 0 if @logColors[@log.i] is undefined
    console.log chalk[@logColors[@log.i]] arguments...
  logColors: ['green','magenta','cyan']
  logColorChange: ->
    @log.i++
    @logColors[@log.i]

  getSpecGlobs: (specDir,recursive=null)->
    globs= []

    specDir= path.join specDir,'**' if recursive?

    globs.push path.join specDir,'*[sS]pec.js'
    globs.push path.join specDir,'*[sS]pec.coffee'
    globs

  getScriptGlobs: (libDir,specDir,recursive=null)->
    globs= []

    cwd= '.' if specDir isnt '.'
    libDir= path.join(libDir,'**') if recursive?
    specDir= path.join(specDir,'**') if recursive?

    globs.push path.join(cwd,'*.coffee') if cwd?
    globs.push path.join libDir,'*.coffee'
    globs.push path.join specDir,'*.coffee'
    globs

{
  path,child_process,events,

  cli,gulpSrcFiles,
  gulp,watch,jasmine,
  rimraf,
  chalk
}= require('node-module-all')
  rename:
    commander: 'cli'
    'gulp-src-files': 'gulpSrcFiles'
  replace: (changedName)-> changedName.replace /^gulp-/,''
  builtinLibs: true

module.exports= jasminetea