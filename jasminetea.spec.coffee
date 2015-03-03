jasminetea= require './'

try
  bin= 'node '+require.resolve 'jasminetea/jasminetea'
catch notLink
  bin= 'node ./jasminetea'
buildScript= (args...)->
  execArgs= bin.split /\s+/
  execArgs.push arg for arg in args
  execArgs

specDir= 'test/10'
specErrorDir= 'test'
{child_process,fs}= require('node-module-all') builtinLibs: true

describe bin,->
  describe 'Standard usage',->
    it 'Default current files',(done)->
      script= buildScript(specDir,'-v').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain('Found 1 files')
        done()

  describe 'Options',->
    it 'Use -c Use ibrik, Code coverage calculation',(done)->
      script= buildScript(specDir,'-c').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain('Coverage summary')
        done()

    it 'Use -r Execute specs in recursive directory',(done)->
      script= buildScript(specDir,'-vr').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain('Found 5 files')
        done()

    it 'Use -s Output stack trace',(done)->
      script= buildScript('test','-s').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain('catch me')
        done()

    it 'Use -w Watch globs changes',(done)->
      [script,args...]= buildScript(specDir,'-rvw',specDir+'/**/*.coffee')

      found= no
      changed= no

      child= child_process.spawn script,args
      child.stdout.on 'data',(message)->
        if found is no
          found= yes
          expect(message.toString()).toContain('Found 5 files')

          setTimeout ->
            changed= yes
            filename= specDir+'/01/03.coffee'
            fs.writeFileSync filename,fs.readFileSync(filename).toString()
          ,500

        if changed
          expect(message.toString()).toContain('File was changed')

          child.kill()
          return done()

    it 'Use -t Success time-limit',(done)->
      script= buildScript(specDir,'-t','1').join ' '
      child_process.exec script,(error,stdout,stderr)->
        error= error.stack.toString()

        expect(error).toContain('asynchronous test timed out')
        done()

    it 'Use -l coffeelint after success',(done)->
      script= buildScript(specDir,'-l','"test/**/*.coffee"').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain('0 errors and 0 warnings in 7 files')
        done()

  describe 'Extra',->
    it 'Use -crswtl',(done)->
      [script,args...]= buildScript specDir,'-rvw',specDir+'/**/*.coffee','-t','1000','-crs','-l','"test/**/*.coffee"'

      found= no
      changed= no

      child= child_process.spawn script,args
      child.stdout.on 'data',(message)->
        if found is no
          found= yes
          expect(message.toString()).toContain('Found 5 files')

          setTimeout ->
            changed= yes
            filename= specDir+'/01/03.coffee'
            fs.writeFileSync filename,fs.readFileSync(filename).toString()
          ,500

        if changed
          expect(message.toString()).toContain('File was changed')

          child.kill()
          return done()

  describe 'Tools',->
    it 'jasminetea.noop is nextTick "close" EventEmitter',(done)->
      jasminetea.noop().on 'close',done