jasminetea= require '../'
try
  bin= require.resolve 'jasminetea/jasminetea'
catch notLink
  bin= require.resolve '../jasminetea'

{path,events,childProcess,fs}= require('node-module-all')
  change: 'camelCase'
  builtinLibs: true

debug= off # show raw command arguments

specDir= path.join __dirname,'fixtures'
run= (args)->
  [script,args...]= args

  console.log "\n",script,args.join ' ' if debug is on

  stdout= ''
  child= childProcess.spawn script,args
  child.stderr.on 'error',(error)-> throw error
  child.stdout.on 'data',(buffer)-> stdout+= buffer.toString()
  child.once 'close',-> child.emit 'done',stdout
  child

describe specDir,->
  it 'Default current files',(done)->
    args= []
    args.push 'node'
    args.push bin
    args.push specDir

    run(args).once 'done',(stdout)->
      expect(stdout).toMatch 'Found'

      done()

  it 'Use -rwcvtsl Fullstack.',(done)->
    args= []
    args.push 'node'
    args.push bin
    args.push specDir
    args.push '--recursive'
    args.push '--watch'
    args.push '--cover'
    args.push '--verbose'
    args.push '--timeout'
    args.push '5000'
    args.push '--stacktrace'
    args.push '--lint'

    runner= run args
    runner.stdout.on 'data',(buffer)->
      if buffer.toString().match /Watching files by/g
        setTimeout ->
          filename= path.join specDir,'01.spec.coffee'
          filename= path.resolve process.cwd(),filename
          fs.writeFileSync filename,fs.readFileSync(filename)
        ,750

      if buffer.toString().match /has been changed/g
        runner.kill()

    runner.once 'done',(stdout)->
      messages= [
        'Found'
        'Running 2 specs'
        'The Catcher in the Rye'
        'Coverage summary'
        'Lint'
        'has been changed'
      ]
      expect(stdout).toMatch message for message in messages

      done()

    describe 'Tools',->
      it 'jasminetea.noop is nextTick "close" EventEmitter',(done)->
        jasminetea.noop().on 'close',done