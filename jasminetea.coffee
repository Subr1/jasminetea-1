jasminetea=
  cli:->
    commander= require 'commander'
    commander
      .version require('./package.json').version
      .usage 'spec_dir [options...]'
      .option '-r recursive','Execute specs in recursive directory'
      .option '-w watch','Watch spec changes'
      .option '-p plumber','Watch spawn mode(slowly)'

      .option '-v verbose','Output spec names'
      .option '-s stacktrace','Output stack trace'
      .option '-t timeout <msec>','Success time-limit <500 msec>',500
      .parse process.argv
    commander.help() if commander.args.length is 0
    
    return jasminetea.exec commander if '-exec' in process.argv
    args= process.argv[1..]
    args.push '-exec'

    jasminetea.spawn args if commander.plumber
    jasminetea.exec commander if commander.plumber is undefined

    if commander.watch
      specFiles= jasminetea.resolve commander

      watch= require 'gulp-watch'
      watch specFiles,->
        jasminetea.spawn args if commander.plumber
        jasminetea.exec commander if commander.plumber is undefined

  spawn:(args)->
    spawn= require('child_process').spawn
    spawn process.argv[0],args,stdio:'inherit',cwd:process.cwd()

  exec:(commander)->
    gulp= require 'gulp'
    gulp.src jasminetea.resolve commander
      .pipe require('gulp-jasmine')
        verbose: commander.verbose
        includeStackTrace: commander.stacktrace
        timeout: commander.timeout

  resolve:(commander)->
    path= require 'path'
    specDir= path.resolve commander.args[0]
    specFiles= [
      "#{specDir}/*[sS]pec.js"
      "#{specDir}/*[sS]pec.coffee"
    ]
    if commander.recursive
      specFiles= [
        "#{specDir}/**/*[sS]pec.js"
        "#{specDir}/**/*[sS]pec.coffee"
      ]
    specFiles

module.exports= jasminetea