jasminetea= new (require '../lib/')
properties= Object.keys jasminetea.__proto__
i= 1

describe 'Jasminetea',->
  it "#{i++} constructor",->
    expect(jasminetea.constructor.name).toBe 'Jasminetea'

  it "#{i++} config is protractor config",->
    expect(typeof jasminetea.config).toBe 'object'

  # TODO circular
  xit "#{i++} cli is API entry point",->
    expect(jasminetea.cli()).toBe undefined
    throw new Error 'nothing'

  # TODO conflict with myself
  xit "#{i++} run is Collection entry point",(done)->
    runner= jasminetea.run ['test/fixtures/spec.coffee']
    runner.on 'close',(code)->
      expect(code).toEqual 0
      expect(runner.constructor).toEqual require('events').EventEmitter
      done()

  it "#{i++} watch is chokidar wrapper",->
    manager= jasminetea.watch watch:['test/fixtures/spec.coffee']
    expect(manager.constructor).toEqual require('events').EventEmitter

  it "... #{properties.length} properties is defined",->
    expect(properties).toEqual [
      'constructor'
      'cli'
      'run'
      'cover'
      'watch'
      'config'
    ]