jasminetea=
  cli:->
    cli
      .version require('./package.json').version
      .usage 'spec_dir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-w --watch <globs>','Watch file changes by <globs> (can use "," separator)',null

      .option '-v --verbose','Output spec names'
      .option '-t --timeout <msec>','Success time-limit <500 msec>',500
      .option '-s --stacktrace','Output stack trace'

      .option '-l --lint <globs>','Use coffeelint after test',(globs)->
        cli.lintFiles= []
        cli.lintFiles.push path.relative process.cwd(),file for file in gulpSrcFiles globs.split ','
        globs
      .parse process.argv
    cli.help() if cli.args.length is 0

    globs= (path.resolve process.cwd(),glob for glob in @resolve cli.args[0],cli.recursive)
    files= (path.relative process.cwd(),glob for glob in globs)
    @log "Found #{gulpSrcFiles(globs).length} files by",files.join(' or '),'...'

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
        @watch cli if cli.watch && firstRun is yes

        @lint cli if cli.lint?

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

{cli,gulp,jasmine,chalk,watch,path,child_process,gulpSrcFiles}= require('node-module-all')
  rename:
    commander: 'cli'
    'gulp-src-files': 'gulpSrcFiles'
  replace: (changedName)-> changedName.replace /^gulp-/,''
  builtinLibs: true

module.exports= jasminetea