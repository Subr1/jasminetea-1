# Dependencies
equal= (require 'power-assert').equal

fs= require 'fs'

Result= (require '../src/result').Result
result= new Result __dirname+'/result.json'

# Specs
describe 'Result',->
  after ->
    try
      fs.unlinkSync result.logPath

  it 'get',->
    length= Object.keys(result.get()).length

    equal length, 0

  it 'set',->
    childExitCode= result.set 1

    equal childExitCode,1

  it 'latest',->
    childExitCode= result.latest()

    equal childExitCode,1
    
  it 'clear',->
    result.clear()

    equal fs.readFileSync(result.logPath),'{}'
    