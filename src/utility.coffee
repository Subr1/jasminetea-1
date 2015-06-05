# Dependencies
Command= (require 'commander').Command
chalk= require 'chalk'
ms= require 'ms'

path= require 'path'

# Public
class Utility extends Command
  getSpecGlobs: (specDir,recursive=null,filename='*[sS]pec.coffee')->
    specDir= path.join specDir,'**' if recursive?

    globs= []
    globs.push path.join specDir,filename
    globs

  getScriptGlobs: (srcDir,specDir,recursive=null,filename='*.coffee')->
    cwd= '.' if specDir isnt '.'
    srcDir= path.join(srcDir,'**') if recursive?
    specDir= path.join(specDir,'**') if recursive?

    globs= []
    globs.push path.join(cwd,filename) if cwd?
    globs.push path.join srcDir,filename
    globs.push path.join specDir,filename
    globs

  parseGlobs: (globs,scripts)->
    if typeof globs is 'string'
      globs.split ',' 
    else
      scripts

  deleteRequireCache: (id)=>
    return if id.indexOf('node_modules') > -1

    files= require.cache[id]
    if files?
      @deleteRequireCache file.id for file in files.children
    
    delete require.cache[id]

  icon: chalk.magenta ' 7_P'
  prev: Date.now()
  log: (args...)->
    diff= Date.now()-@prev
    time= chalk.gray ('     +'+ms(diff)).slice -7
    @prev= Date.now()

    @output @icon+time+' '+(args.join ' ')

  output: (text)->
    return text if @test

    console.log text

  whereabouts: (args,conjunctive=' and ')->
    args= [args] if typeof args is 'string'
    
    (chalk.underline arg for arg in args).join(conjunctive)

module.exports= Utility