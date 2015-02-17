jasminetea=
  cli:->
    commander= require 'commander'
    commander
      .version require('./package.json').version
      .usage 'spec_dir [options...]'
      .option '-r recursive','Execute specs in recursive directory'
      .option '-w watch','Watch spec changes'

      .option '-v verbose','Output spec names'
      .option '-s stacktrace','Output stack trace'
      .option '-t timeout <msec>','Success time-limit <500 msec>',500
      .parse process.argv
    commander.help() if commander.args.length is 0

    path= require 'path'
    gulp= require 'gulp'
    watch= require 'gulp-watch'
    jasmine= require 'gulp-jasmine'

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

    process.nextTick -> gulp.start 'jasminetea'

    gulp.task 'jasminetea',['jasminetea_run'],->
      if commander.watch
        watch specFiles,-> gulp.start 'jasminetea'
    gulp.task 'jasminetea_run',->
      gulp.src specFiles
        .pipe jasmine
          verbose: commander.verbose
          includeStackTrace: commander.stacktrace
          timeout: commander.timeout

module.exports= jasminetea