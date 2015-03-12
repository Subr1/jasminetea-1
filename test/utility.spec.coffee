utility= new (require '../lib/utility')
properties= Object.keys utility.__proto__
i= 1

describe "Utility",->
  it "#{i++} logColors is Sliced method names of chalk",->
    expect(utility.logColors).toEqual ['magenta','cyan','green','yellow']

  it "#{i++} logBgColors is Sliced method names of chalk",->
    expect(utility.logBgColors).toEqual ['bgMagenta','bgCyan','bgGreen','bgYellow']

  it "#{i++} h1 is console.log beautifier",->
    expect(utility.h1 'hoge').toBe undefined

  it "#{i++} log is console.log highlighter",->
    expect(utility.log 'hoge').toBe undefined

  it "#{i++} getColor return chalk color instance",->
    expect(utility.getColor()._styles[0]).toBe 'magenta'

  it "#{i++} getBgColor return chalk bgColor instance",->
    expect(utility.getBgColor()._styles[0]).toBe 'bgMagenta'

  it "#{i++} noop is EventEmitter of Fake",(done)->
    noop= utility.noop()
    noop.on 'close',(code)->

      expect(code).toEqual 0
      expect(noop.constructor).toEqual require('events').EventEmitter
      done()

  it "#{i++} getSpecGlobs return globs",->
    expect(utility.getSpecGlobs '.').toEqual ['*[sS]pec.coffee']
    expect(utility.getSpecGlobs '.',yes).toEqual ['**/*[sS]pec.coffee']

    expect(utility.getSpecGlobs '.',yes,'*.coffee').toEqual ['**/*.coffee']

  it "#{i++} getScriptGlobs",->
    expect(utility.getScriptGlobs 'lib','test').toEqual ['*.coffee','lib/*.coffee','test/*.coffee']
    expect(utility.getScriptGlobs 'lib','test',yes).toEqual ['*.coffee','lib/**/*.coffee','test/**/*.coffee']

  it "... #{properties.length} properties is defined",->
    expect(properties).toEqual [
      'logColors'
      'logBgColors'
      'h1'
      'log'
      'getColor'
      'getBgColor'
      'noop'
      'getSpecGlobs'
      'getScriptGlobs'
    ]
