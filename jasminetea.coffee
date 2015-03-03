jasminetea=
  cli:->
    cli
      .version require('./package').version
      .usage 'spec_dir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-w --watch <globs>','Watch file changes by <globs> (can use "," separator)',null
      .option '-c --cover','Use ibrik, Code coverage calculation',(cover)-> if '-C' in process.argv then no else cover
      
      .option '-v --verbose','Output spec names'
      .option '-t --timeout <msec>','Success time-limit <500 msec>',500
      .option '-s --stacktrace','Output stack trace'

      .option '-l --lint <globs>','Use coffeelint, Code linting after success',(globs)->
        cli.lintFiles= []
        cli.lintFiles.push path.relative process.cwd(),file for file in gulpSrcFiles globs.split ','
        globs
      .parse process.argv
    cli.help() if cli.args.length is 0

    return @cover(cli) if cli.cover is yes

    globs= (path.resolve process.cwd(),glob for glob in @resolve cli.args[0],cli.recursive)
    @files= (path.relative process.cwd(),glob for glob in globs)
    @log "Found #{gulpSrcFiles(globs).length} files by",@files.join(' or '),'...'

    @run cli

  run: (cli,firstRun=true)->   
    gulp.src @resolve cli.args[0],cli.recursive
      .pipe jasmine
        verbose: cli.verbose
        timeout: cli.timeout
        includeStackTrace: cli.stacktrace
      .on 'data',-> null
      .on 'error',=>
        @watch cli if cli.watch && firstRun is yes
      .on 'end',=>
        lint= @noop
        lint= @lint if cli.lint?
        lint.call(this,cli).on 'close',=>
          @watch cli if cli.watch && firstRun is yes

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

  watch: (cli)->
    files= cli.watch.split ','
    globs= (path.resolve process.cwd(),glob for glob in files)

    @log 'Wathing files by',files.join(' or '),'...'
    watch globs,=>
      @logColorChange()
      @log 'File was changed by',files.join(' or ')
      @run cli,false

  lint: (cli)->
    args= [require.resolve 'coffeelint/bin/coffeelint']
    args.push file for file in cli.lintFiles

    @log ''
    @log 'Next, linting ...'
    spawned= child_process.spawn 'node',args,stdio:'inherit',cwd:process.cwd()
    spawned.on 'close',=>
      @log 'Linted from',cli.lint.split(',').join(' or ')
    spawned

  logColors: ['green','magenta','cyan']
  log: ->
    @log.i= 0 if @logColors[@log.i] is undefined
    console.log chalk[@logColors[@log.i]] arguments...
  logColorChange: ->
    @log.i++
    @logColors[@log.i]

  resolve:(specDir,recursive=false)->
    specDir= path.resolve process.cwd(),specDir
    specFiles= [
      "#{specDir}/*[sS]pec.js"
      "#{specDir}/*[sS]pec.coffee"
    ]
    if recursive
      specFiles= [
        "#{specDir}/**/*[sS]pec.js"
        "#{specDir}/**/*[sS]pec.coffee"
      ]
    specFiles

{cli,gulp,jasmine,chalk,watch,path,child_process,gulpSrcFiles,events,rimraf}= require('node-module-all')
  rename:
    commander: 'cli'
    'gulp-src-files': 'gulpSrcFiles'
  replace: (changedName)-> changedName.replace /^gulp-/,''
  builtinLibs: true

module.exports= jasminetea