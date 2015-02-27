jasminetea=
  cli:->
    cli= require 'commander'
    cli
      .version require('./package.json').version
      .usage 'spec_dir [options...]'
      .option '-r --recursive','Execute specs in recursive directory'
      .option '-w --watch <globs>','Watch file changes by <globs> (can use "," separator)',null

      .option '-v --verbose','Output spec names'
      .option '-t --timeout <msec>','Success time-limit <500 msec>',500
      .option '-s --stacktrace','Output stack trace'
      .parse process.argv
    cli.help() if cli.args.length is 0

    @run cli

  run: (cli,firstRun=true)->
    gulp= require 'gulp'
    gulp.src @resolve cli.args[0],cli.recursive
      .pipe require('gulp-jasmine')
        verbose: cli.verbose
        timeout: cli.timeout
        includeStackTrace: cli.stacktrace
      .on 'data',-> null
      .on 'error',=> @watch cli if cli.watch && firstRun is yes
      .on 'end'  ,=> @watch cli if cli.watch && firstRun is yes

  watch: (cli)->
    i= 0
    chalk= require 'chalk'
    chalkColors= ['red','green','yellow','magenta','cyan','gray']

    path= require 'path'
    globs= (path.resolve process.cwd(),glob for glob in cli.watch.split(','))
    console.log chalk[chalkColors[i++]]('Wathing files by',globs.join(' or '),'...')

    watch= require 'gulp-watch'
    watch globs,=>
      i= 0 if i>=chalkColors.length
      console.log chalk[chalkColors[i++]]('File was changed by',globs.join(' or '))
      @run cli,false

  resolve:(specDir,recursive=false)->
    specDir= require('path').resolve process.cwd(),specDir
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

module.exports= jasminetea