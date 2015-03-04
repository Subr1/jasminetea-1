jasminetea= require './'

try
  bin= 'node '+require.resolve 'jasminetea/jasminetea'
catch notLink
  bin= 'node ./jasminetea'
buildScript= (args...)->
  execArgs= bin.split /\s+/
  execArgs.push arg for arg in args
  execArgs

{child_process,fs,path}= require('node-module-all') builtinLibs: true

specDir= path.join 'test','10'
specErrorDir= 'test'

describe bin,->
  describe 'Standard usage',->
    it 'Default current files',(done)->
      script= buildScript(specDir).join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain 'Found 1 files'
        done()

  describe 'Options',->
    it 'Use -v Output spec name',(done)->
      script= buildScript(specDir,'-v').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain '08.spec.coffee'
        done()

    it 'Use -c Use ibrik, Code coverage calculation',(done)->
      script= buildScript(specDir,'-c').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain 'Coverage summary'
        done()

    it 'Use -r Execute specs in recursive directory',(done)->
      script= buildScript(specDir,'-vr').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain 'Found 5 files'
        done()

    it 'Use -s Output stack trace',(done)->
      script= buildScript('test','-s').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain 'catch me'
        done()

    it 'Use -w Watch globs changes',(done)->
      [script,args...]= buildScript(specDir,'-rvw',specDir+'/**/*.coffee')

      found= no
      changed= no

      child= child_process.spawn script,args
      child.stdout.on 'data',(message)->
        if found is no
          found= yes
          expect(message.toString()).toContain 'Found 5 files'

          setTimeout ->
            changed= yes
            filename= specDir+'/01/03.coffee'
            fs.writeFileSync filename,fs.readFileSync(filename).toString()
          ,500

        if changed
          expect(message.toString()).toContain 'File was changed'

          done()
          child.kill()

    it 'Use -l coffeelint after success',(done)->
      script= buildScript(specDir,'-l','"test/**/*.coffee"').join ' '
      child_process.exec script,(error,stdout)->
        throw error if error?

        expect(stdout.toString()).toContain '0 errors and 0 warnings in 7 files'
        done()

    it 'Use -t Success time-limit',(done)->
      script= buildScript(specDir,'-t','1').join ' '
      child_process.exec script,(error,stdout,stderr)->
        error= error.stack.toString()

        expect(error).toContain 'asynchronous test timed out'
        done()

  describe 'Extra',->
    child= null

    afterEach ->
      child.kill -child.pid if child?.connected

    it 'Use -vcrswlt Fullstack.',(done)->
      [script,args...]= buildScript(path.join(specDir,'01'),'-vcrswlt','5000') # specDir -r is throw

      busy= yes
      stdout= ''
      child= child_process.spawn script,args,detached:true
      child.stdout.on 'data',(buffer)->
        stdout+= buffer.toString()
        if busy and stdout.match /Wathing/g
          busy= no

          setTimeout ->
            filename= specDir+'/01/03.coffee'
            fs.writeFileSync filename,fs.readFileSync(filename).toString()

            setTimeout ->
              expect(stdout).toContain 'Running 3 specs.'
              expect(stdout).toContain 'Finished in'
              expect(stdout).toContain 'Next, linting'
              expect(stdout).toContain 'Linted from'
              expect(stdout).toContain 'Wathing files by'
              expect(stdout).toContain 'File was changed'


              done()
            ,500
          ,100

  describe 'Tools',->
    it 'jasminetea.noop is nextTick "close" EventEmitter',(done)->
      jasminetea.noop().on 'close',done