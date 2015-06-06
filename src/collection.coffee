# Dependencies
Utility= (require './utility').Utility

Promise= require 'bluebird'

Jasmine= require 'jasmine'
Reporter= require 'jasmine-terminal-reporter'
wanderer= require 'wanderer'
chalk= require 'chalk'

fs= require 'fs'
path= require 'path'
{exec,spawn}= require 'child_process'

# Public
class Collection extends Utility
  # Pass specs to Jasmine via CLI.jasminetea
  doRun: (specs,{silent,stacktrace,timeout}={})->
    passed= 0
    failure= no

    jasmine= new Jasmine
    jasmine.addReporter new Reporter
      showColors: true
      isVerbose: not silent
      includeStackTrace: stacktrace
    jasmine.jasmine.DEFAULT_TIMEOUT_INTERVAL= timeout

    new Promise (resolve)=>
      jasmine.addReporter
        specDone: (result)->
          failure= yes if result.status is 'failed'
          passed++ if result.status is 'passed'

        jasmineDone: ->
          resolve()

      count= 0
      wanderer.seek specs
        .on 'data',(file)=>
          count++
          filename= path.resolve process.cwd(),file

          @deleteRequireCache require.resolve filename
          
          jasmine.addSpecFile filename
        .once 'end',=>
          if count is 0
            @log chalk.red 'Spec not exists in',@whereabouts(specs)

            return resolve()

          @log "Found #{count} files in",@whereabouts(specs),'...\n'
          try
            jasmine.execute()
          catch error
            failure= yes
            console.log error?.stack?.toString() ? error?.message ? error

            resolve()

    .then ->
      failure= yes if passed is 0

      cover= ('-c' in process.argv) or ('--cover' in process.argv)
      if cover
        if jasmine.specFiles.length
          @log 'Calculating...'
        else
          @log 'Skip --cover.  Because not exists in',@whereabouts(specs)

      failure

  # Pass all .coffee to coffeelint
  doLint: (files)->
    options=
      cwd: process.cwd()
      env: process.env
      stdio: 'inherit'

    new Promise (resolve)=>
      files= wanderer.seekSync files
      if files.length is 0
        @log 'Skip --lint.   Because not exists in',@whereabouts(files)
        return resolve null
      
      argv= [require.resolve 'coffeelint/bin/coffeelint']
      argv.push path.relative process.cwd(),file for file in files
      if fs.existsSync path.join process.cwd(),'.coffeelintrc'
        argv.push '-f'
        argv.push '.coffeelintrc'
      @logDebug '$',argv.join ' '

      @log '$ node ',argv.join ' ' if @debug
      @log 'Lint in',@whereabouts(files),'...'

      spawn 'node',argv,options
      .on 'exit',(code)->
        resolve code

  # Re-execute jasminetea at ibrik
  doCover: ->
    options=
      cwd: process.cwd()
      env: process.env
      stdio: [0,1,'ignore'] # Inherit ansi color

    new Promise (resolve)=>
      argv= []
      argv.push 'node'
      argv.push require.resolve 'ibrik/bin/ibrik'
      argv.push 'cover'
      argv.push require.resolve '../jasminetea'
      argv.push '--'
      argv= argv.concat process.argv[2...]
      @logDebug '$',argv.join ' '

      [script,argv...]= argv
      spawn script,argv,options
      .on 'exit',(code)->
        resolve code

  # Send lcov.info to coveralls.io
  doReport: ->
    options=
      cwd: process.cwd()
      env: process.env
      maxBuffer: 1000*1024

    new Promise (resolve,reject)=>
      existsToken= fs.existsSync path.join process.cwd(),'.coveralls.yml'
      existsToken= process.env.COVERALLS_REPO_TOKEN? if not existsToken
      if not existsToken
        @log 'Skip --report. Because not exists the COVERALLS_REPO_TOKEN'
        return resolve null

      existsCoverage= fs.existsSync path.join process.cwd(),'coverage','lcov.info'
      if not existsCoverage
        @log 'Skip --report. Because not exists the ./coverage/lcov.info'
        return resolve null

      argv= []
      argv.push 'cat'
      argv.push path.join process.cwd(),'coverage','lcov.info'
      argv.push '|'
      argv.push require.resolve 'coveralls/bin/coveralls.js'
      @logDebug '$',argv.join ' '

      exec argv.join(' '),options,(error)=>
        return reject error if error?

        @log 'Posted a coverage report.'
        resolve null

module.exports= new Collection
module.exports.Collection= Collection