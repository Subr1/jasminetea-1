utility= new (require '../lib/utility')
properties= Object.keys utility.__proto__
i= 1

describe "Utility",->
  it "#{i++} logColors",->
    expect(utility.logColors).toEqual ['magenta','cyan','green','yellow']
  it "#{i++} logBgColors",->
    expect(utility.logBgColors).toEqual ['bgMagenta','bgCyan','bgGreen','bgYellow']

  it "#{i++} h1",->
    expect(utility.h1 'hoge').toBe undefined
  it "#{i++} log",->
    expect(utility.log 'hoge').toBe undefined

  it "#{i++} getColor",->
    expect(utility.getColor()._styles[0]).toBe 'magenta'
  it "#{i++} getBgColor",->
    expect(utility.getBgColor()._styles[0]).toBe 'bgMagenta'
  it "#{i++} noop",->
    expect(utility.noop().constructor).toEqual require('events').EventEmitter

  it "#{i++} getSpecGlobs",->
    expect(utility.getSpecGlobs '.').toEqual ['*[sS]pec.coffee']
    expect(utility.getSpecGlobs '.',yes).toEqual ['**/*[sS]pec.coffee']

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
