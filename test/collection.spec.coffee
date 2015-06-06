# Dependencies
equal= (require 'power-assert').equal

Collection= (require '../src/collection').Collection
collection= new Collection
collection.test= yes

# Specs
describe 'Collection',->
  it 'doRun',(done)->
    specs= []

    collection.doRun specs
    .then (failure)->
      equal failure, yes
      done()

  xit 'doLint',(done)->
    done()

  xit 'doCover',(done)->
    done()

  xit 'doReport',(done)->
    done()
