collection= new (require '../lib/collection')
properties= Object.keys collection.__proto__
i= 1

describe 'Collection',->
  it "#{i++} constructor",->
    expect(collection.constructor.name).toBe 'Collection'
  it "#{i++} runJasmine",->
    # runner= collection.runJasmine [],{}
    # conflict? runJasmine > runJasmine

  xit "#{i++} runProtractor",->
  xit "#{i++} protractor",->
  xit "#{i++} webdriverUpdate",->
  xit "#{i++} webdriverStart",->
  xit "#{i++} webdriverKill",->
  xit "#{i++} deleteRequireCache",->
  xit "#{i++} cover",->
  xit "#{i++} report",->
  xit "#{i++} lint",->

  it "... #{properties.length} properties is defined",->
    expect(properties).toEqual [
      'constructor'
      'runJasmine'
      'runProtractor'
      'protractor'
      'webdriverUpdate'
      'webdriverStart'
      'webdriverKill'
      'deleteRequireCache'
      'cover'
      'report'
      'lint'
    ]