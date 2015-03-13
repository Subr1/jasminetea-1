collection= new (require '../lib/collection')
properties= Object.keys collection.__proto__
i= 1

describe 'Collection',->
  it "#{i++} constructor",->
    expect(collection.constructor.name).toBe 'Collection'

  # TODO conflict jasinetea itself
  xit "#{i++} runJasmine is Jasmine wrapper",(done)->
    runner= collection.runJasmine 'test/fixtures/spec.coffee'
    runner.on 'close',(code)->
      expect(code).toEqual 0
      expect(runner.constructor).toEqual require('events').EventEmitter
      done()

  it "#{i++} runProtractor is webdriber setup",(done)->
    runner= collection.runProtractor 'test/fixtures/spec.coffee'
    runner.on 'close',(code)->
      expect(code).toEqual 0
      expect(runner.constructor).toEqual require('events').EventEmitter
      done()

  it "#{i++} protractor is protractor wrapper",(done)->
    childProcess= collection.protractor 'test/fixtures/spec.coffee'
    childProcess.on 'close',(code)->
      expect(code).toEqual 0
      done()
    
  it "#{i++} webdriverUpdate is `webdriver-manager update`",(done)->
    childProcess= collection.webdriverUpdate()
    childProcess.on 'close',(code)->
      expect(code).toEqual 0
      done()

  it "#{i++} deleteRequireCache is delete require.cache for watch",->
    id= require.resolve __filename

    collection.deleteRequireCache id
    expect(require.cache[id]).toEqual undefined
  
  # TODO circular
  xit "#{i++} cover",(done)->
    childProcess= collection.cover()
    childProcess.on 'close',(code)->
      expect(code).toEqual 0
      done()
      
  it "#{i++} report",(done)->
    childProcess= collection.report()
    childProcess.on 'close',(code)->
      expect(code).toEqual 0
      done()
      
  it "#{i++} lint",(done)->
    childProcess= collection.lint lint:['test/fixtures/*.coffee']
    childProcess.on 'close',(code)->
      expect(code).toEqual 0
      done()

  it "... #{properties.length} properties is defined",->
    expect(properties).toEqual [
      'constructor'

      'runJasmine'
      'coverJasmine'

      'runProtractor'
      'protractor'
      'coverProtractor'
      
      'webdriverUpdate'

      'deleteRequireCache'

      'report'
      'lint'
    ]