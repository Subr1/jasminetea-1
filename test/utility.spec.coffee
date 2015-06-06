# Dependencies
equal= (require 'power-assert').equal

Utility= (require '../src/utility').Utility
utility= new Utility
utility.test= yes

chalk= require 'chalk'

# Specs
describe 'Utility',->
  it 'deleteRequireCache',->
    id= require.resolve '../src'
    cache= require.cache[id]
    children= cache.children

    utility.deleteRequireCache id

    equal require.cache[id], undefined
    for child in children
      continue if child.id.indexOf('node_modules') isnt -1

      equal require.cache[child.id], undefined

  it 'getSpecGlobs',->
    globs= utility.getSpecGlobs '.','*.coffee'
    equal globs[0], '*.coffee'

    globs= utility.getSpecGlobs '.','*.coffee',true
    equal globs[0], '**/*.coffee'

  it 'getScriptGlobs',->
    globs= utility.getScriptGlobs '.','.'
    equal globs[0], '*.coffee'
    equal globs[1], '*.coffee'

    globs= utility.getScriptGlobs 'src','test'
    equal globs[0], '*.coffee'
    equal globs[1], 'src/*.coffee'
    equal globs[2], 'test/*.coffee'

    globs= utility.getScriptGlobs 'src','test',true
    equal globs[0], '*.coffee'
    equal globs[1], 'src/**/*.coffee'
    equal globs[2], 'test/**/*.coffee'

  it 'parseGlobs',->
    globs= utility.parseGlobs 'foo,bar,baz'

    equal globs[0], 'foo'
    equal globs[1], 'bar'
    equal globs[2], 'baz'

  it 'icon',->
    equal typeof utility.icon, 'string'

  it 'prev',->
    equal typeof utility.prev, 'number'

  it 'log',->
    text= utility.log 'foo'
    equal text.slice(0,14), utility.icon
    equal text.slice(-3), 'foo'

    text= utility.log 'foo','bar'
    equal text.slice(0,14), utility.icon
    equal text.slice(-7).slice(0,3), 'foo'
    equal text.slice(-3), 'bar'

  it 'logDebug',->
    utility.debug= yes

    text= utility.logDebug 'foo'
    equal text, 'foo'
    
    utility.debug= no
    text= utility.logDebug 'foo'
    equal text, undefined

  it 'output',->
    text= utility.output 'noop'
    equal text, 'noop'

  it 'whereabouts',->
    texts= utility.whereabouts 'foo'
    equal texts, chalk.underline 'foo'

    texts= utility.whereabouts ['foo','bar']
    equal texts, (chalk.underline 'foo')+' and '+(chalk.underline 'bar')
