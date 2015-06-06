# Dependencies
Command= (require 'commander').Command
chalk= require 'chalk'
ms= require 'ms'

path= require 'path'

# Public
class Utility extends Command
  deleteRequireCache: (id)=>
    return if id.indexOf('node_modules') isnt -1

    files= require.cache[id]
    if files?
      @deleteRequireCache file.id for file in files.children
    
    delete require.cache[id]
  
  # string parsers

  getSpecGlobs: (specDir,specFile,recursive=null)->
    specDir= path.join specDir,'**' if recursive?

    globs= []
    globs.push path.join specDir,specFile
    globs

  getScriptGlobs: (srcDir,specDir,recursive=null)->
    cwd= '.' if specDir isnt '.'
    srcDir= path.join srcDir,'**' if recursive?
    specDir= path.join specDir,'**' if recursive?

    globs= []
    globs.push path.join cwd,'*.coffee' if cwd?
    globs.push path.join srcDir,'*.coffee'
    globs.push path.join specDir,'*.coffee'
    globs

  parseGlobs: (globs,defaults)->
    if typeof globs is 'string'
      globs.split ','
    else
      defaults

  # Formats

  icon: chalk.magenta ' 7_P'
  prev: Date.now()
  log: (args...)->
    diff= Date.now()-@prev
    time= chalk.gray ('     +'+ms(diff)).slice -7
    @prev= Date.now()

    @output @icon+time+' '+(args.join ' ')

  logDebug: (text)->
    @output text if @debug

  output: (text)->
    return text if @test

    console.log text

  whereabouts: (args,conjunctive=' and ')->
    args= [args] if typeof args is 'string'
    
    (chalk.underline arg for arg in args).join(conjunctive)

module.exports= new Utility
module.exports.Utility= Utility