# Dependencies
Command= (require 'commander').Command
chalk= require 'chalk'

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

  logColors: ['magenta','cyan','green','yellow']
  logBgColors: ['bgMagenta','bgCyan','bgGreen','bgYellow']
  log: (args...)->
    [...,changeColor]= args
    args= args[...-1] if changeColor is yes

    return if @silent

    process.stdin.write @getColor(changeColor) '7_P '
    process.stdin.write args.join(' ')+'\n'

  getColor: (changeColor=no)->
    @logI= 0 if @logColors[@logI] is undefined
    color= chalk[@logColors[@logI]]
    @logI++ if changeColor is yes

    color

  getBgColor: (changeColor=no)->
    @logI= 0 if @logBgColors[@logI] is undefined
    color= chalk[@logBgColors[@logI]]
    @logI++ if changeColor is yes

    color

module.exports= Utility