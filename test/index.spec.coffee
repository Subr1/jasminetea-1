jasminetea= new (require '../lib/')
properties= Object.keys jasminetea.__proto__
i= 1

describe 'Jasminetea',->
  it "#{i++} constructor",->
    expect(jasminetea.constructor.name).toBe 'Jasminetea'
  xit "#{i++} config",->
  xit "#{i++} cli",->
  xit "#{i++} run",->
  xit "#{i++} watch",->

  it "... #{properties.length} properties is defined",->
    expect(properties).toEqual [
      'constructor'
      'config'
      'cli'
      'run'
      'watch'
    ]