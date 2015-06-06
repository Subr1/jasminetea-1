# Dependencies
equal= (require 'power-assert').equal

Collection= (require '../src/collection').Collection
collection= new Collection
collection.test= yes

result= require '../src/result'

fs= require 'fs'

# Specs
describe 'Collection',->
  beforeEach ->
    try
      fs.unlinkSync process.cwd()+'/jasminetea.json'
    catch
      

  describe 'doRun',->
    it 'Pass due to 1 spec or more',(done)->
      specs= ['test/fixtures/pass.coffee']

      collection.doRun specs
      .then (failure)->
        equal failure, no
        done()

    it 'Failing due to no specs',(done)->
      specs= []

      collection.doRun specs
      .then (failure)->
        equal failure, yes
        done()

  describe 'doLint',->
    it '1 file',(done)->
      specs= ['test/fixtures/pass.coffee']

      collection.doLint specs
      .then (failure)->
        equal failure, no
        done()

    it 'no file',(done)->
      specs= []

      collection.doLint specs
      .then (failure)->
        equal failure, yes
        done()

  it 'doCover',(done)->
    argv= ['node',__dirname,'nospecDir']

    collection.doCover argv
    .then ->
      childExitCode= result.latest()

      equal childExitCode, 1
      done()

  describe 'doReport',->
    it 'Skip',(done)->
      collection.doReport()
      .then (exitCode)->
        equal exitCode, 0

        done()

    it 'Post',(done)->
      process.env.COVERALLS_REPO_TOKEN= 'fake'
      fs.writeFileSync process.cwd()+'/coverage/lcov.info','''
      TN:
      SF:/Users/59naga/Downloads/jasminetea/src/index.coffee
      FN:2,(anonymous_1)
      end_of_record
      '''

      collection.doReport()
      .catch (error)->
        failedMessage= error.message.match(/Bad response.+/)?[0]
        equal failedMessage,
          'Bad response: 422 {"message":"Couldn\'t find a repository matching this job.","error":true}'

        done()
