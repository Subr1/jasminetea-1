# Dependencies 
Utility= require './utility'

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
  doRun: ->
    passed= 0
    failure= no

    jasmine= new Jasmine
    jasmine.addReporter new Reporter
      showColors: true
      isVerbose: not @silent
      includeStackTrace: @stacktrace
    jasmine.jasmine.DEFAULT_TIMEOUT_INTERVAL= @timeout

    new Promise (resolve)=>
      wanderer.seek @specs
        .on 'data',(file)=>
          filename= path.resolve process.cwd(),file

          @deleteRequireCache require.resolve filename
          
          jasmine.addSpecFile filename
        .once 'end',=>
          count= jasmine.specFiles.length
          failure= yes if count is 0

          if count
            @log "Found #{count} files in",@whereabouts(@specs),'...\n'
          else
            @log chalk.red "Spec not exists in",@whereabouts(@specs)

          console.log ''# Begin...

          try
            jasmine.execute()
          catch error
            failure= yes
            console.log error?.stack?.toString() ? error?.message ? error

            jasmineDone()

      jasmine.addReporter
        specDone: (result)->
          failure= yes if result.status is 'failed'
          passed++ if result.status is 'passed'

        jasmineDone: =>
          jasmineDone()

      jasmineDone= =>
        failure= yes if passed is 0

        console.log ''# End

        cover= ('-c' in process.argv) or ('--cover' in process.argv)
        if cover
          if jasmine.specFiles.length
            @log 'Calculating...'
          else
            @log 'Skip --cover.  Because not exists in',@whereabouts(@specs)

        resolve ~~failure

  doLint: ->
    options=
      cwd: process.cwd()
      env: process.env
      stdio: 'inherit'

    new Promise (resolve)=>
      files= wanderer.seekSync @lint
      if files.length is 0
        @log 'Skip --lint.   Because not exists in',@whereabouts(@lint)
        return resolve null
      
      argv= [require.resolve 'coffeelint/bin/coffeelint']
      argv.push path.relative process.cwd(),file for file in files

      console.log ''# Begin...

      @log '$ node ',argv.join ' ' if @debug
      @log 'Lint by',@whereabouts(@lint),'...'

      spawn 'node',argv,options
      .on 'exit',(code)->
        resolve code

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
      argv.push '--no-cover'

      @log '$',argv.join ' ' if @debug

      [script,argv...]= argv
      spawn script,argv,options
      .on 'exit',(code)->
        resolve code

  doReport: (options={})->
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

      @log '$',argv.join ' ' if @debug

      exec argv.join(' '),options,(error)=>
        return reject error if error?

        @log 'Posted a coverage report.'
        resolve null

module.exports= Collection