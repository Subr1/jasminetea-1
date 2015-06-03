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
  _log: Date.now()
  log: (args...)->
    [...,changeColor]= args
    args= args[...-1] if changeColor is yes

    suffix= ' ms'
    diff= Date.now()-@_log ? 0
    if diff>1000
      diff= ~~(diff/1000)
      suffix= 'sec'
      if diff>60
        diff= ~~(diff/60)
        suffix= 'min'
        if diff>60
          diff= ~~(diff/60)
          suffix= ' hr'

    icon= @getColor(changeColor) ' 7_P'
    time= chalk.gray(('     +'+diff+suffix).slice(-8))

    unless @silent
      process.stdout.write icon+time+' '
      process.stdout.write args.join(' ')+'\n'

    @_log= Date.now()

  whereabouts: (args,conjunctive=' and ')->
    args= [args] if typeof args is 'string'
    
    (chalk.underline arg for arg in args).join(conjunctive)

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