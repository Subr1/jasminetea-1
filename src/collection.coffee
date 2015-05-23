# Dependencies 
Utility= require './utility'

Promise= require 'bluebird'
globWatcher= require 'glob-watcher'

Jasmine= require 'jasmine'
Reporter= require 'jasmine-terminal-reporter'
wanderer= require 'wanderer'

fs= require 'fs'
path= require 'path'
{exec,spawn}= require 'child_process'

# Public
class Collection extends Utility
  doRun: ->
    failure= yes

    jasmine= new Jasmine
    jasmine.addReporter new Reporter
      showColors: true
      isVerbose: @verbose
      includeStackTrace: @stacktrace
    jasmine.jasmine.DEFAULT_TIMEOUT_INTERVAL= @timeout

    new Promise (resolve)=>
      wanderer.seek @specs
        .on 'data',(file)=>
          filename= path.resolve process.cwd(),file

          @deleteRequireCache require.resolve filename
          jasmine.addSpecFile filename
        .once 'end',->
          failure= no if jasmine.specFiles.length is 0

          try
            jasmine.execute()
          catch error
            console.error error?.stack?.toString() ? error?.message ? error
            failure= no

      jasmine.addReporter
        specDone: (result)->
          failure= no if result.status is 'failed'

        jasmineDone: ->
          resolve ~~failure

  doLint: ->
    options=
      cwd: process.cwd()
      env: process.env
      stdio: unless @debug then 'inherit' else undefined

    new Promise (resolve)=>
      argv= [require.resolve 'coffeelint/bin/coffeelint']
      for file in wanderer.seekSync @lint
        argv.push path.relative process.cwd(),file

      @log '$ node ',argv.join ' ' if @debug
      @log 'Lint by',@lint.join(' or '),'...'

      spawn 'node',argv,options
      .on 'exit',(code)->
        resolve code

  doCover: ->
    options=
      cwd: process.cwd()
      env: process.env
      stdio: 'inherit'

    new Promise (resolve)=>
      argv= []
      argv.push 'node'
      argv.push require.resolve 'ibrik/bin/ibrik'
      argv.push 'cover'
      argv.push require.resolve '../jasminetea'
      argv.push '--'
      argv= argv.concat process.argv[2...]
      argv.push '--no-cover'

      @log '$',argv.join ' ' if @debug?

      [script,argv...]= argv
      spawn script,argv,options
      .on 'exit',(code)->
        resolve code

  doReport: (options={})->
    options=
      cwd: process.cwd()
      env: process.env
      maxBuffer: 1000*1024

    new Promise (resolve)=>
      existsToken= fs.existsSync path.join process.cwd(),'.coveralls.yml'
      existsToken= process.env.COVERALLS_REPO_TOKEN? if not existsToken
      if not existsToken
        @log 'Skip post a coverage report. Cause not exists COVERALLS_REPO_TOKEN'
        return resolve null

      existsCoverage= fs.existsSync path.join process.cwd(),'coverage','lcov.info'
      if not existsCoverage
        @log 'Skip post a coverage report. Cause not exists ./coverage/lcov.info'
        return resolve null

      argv= []
      argv.push 'cat'
      argv.push path.join process.cwd(),'coverage','lcov.info'
      argv.push '|'
      argv.push require.resolve 'coveralls/bin/coveralls.js'

      @log '$',argv.join ' ' if @debug

      exec argv.join(' '),options,(error)=>
        throw error.message if error?

        @log 'Posted a coverage report.'
        return resolve null

module.exports= Collection