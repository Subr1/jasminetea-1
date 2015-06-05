# ![][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> is Extension testing framework of [Jasmine2][1] for [CoffeeScript][2] in [Node.js][3].

## Test - Getting started
```bash
.
├─ src
│  └─ index.coffee
└─ test
   └─ api.spec.coffee
```

./src/index.coffee

```coffee
class MyModule
  encode: (str)->
    'data:text/plain;base64,'+(new Buffer str).toString 'base64'

  decode: (datauri)->
    (new Buffer datauri.slice(datauri.indexOf(',')+1),'base64').toString()

module.exports= new MyModule
module.exports.MyModule= MyModule
```

./test/index.coffee

```coffee
MyModule= (require '../src').MyModule
myModule= require '../src'

fixture= 'foo'

describe 'API',->
  datauri= null

  it 'instanceof MyModule',->
    expect(myModule instanceof MyModule).toBe true

  it 'encode',->
    datauri= myModule.encode fixture
    expect(datauri).toBe 'data:text/plain;base64,'+(new Buffer fixture).toString 'base64'
  
  it 'decode',->
    str= myModule.decode datauri 
    expect(str).toBe fixture
```

### 1, 2, 3, Jasminetea!
```bash
$ npm install jasminetea --global
$ jasminetea -V
# 0.2.0-beta.3

$ jasminetea
#
#  7_P +361 ms Found 1 files in test/*[sS]pec.coffee ...
# 
# 
# Running 3 specs.
# 
# API
#     instanceof MyModule: passed
#     encode: passed
#     decode: passed
# 
# 3 specs, 0 failures
# Finished in 0 seconds
```

<!--

## Lint

## Code coverage caluculation

## Watch

## Friendly TravisCI

## Report to coveralls.io

-->

License
=========================
[MIT][License]
[License]: http://59naga.mit-license.org/

[.svg]: https://cdn.rawgit.com/59naga/jasminetea/master/.svg

[npm-image]: https://badge.fury.io/js/jasminetea.svg
[npm]: https://npmjs.org/package/jasminetea
[travis-image]: https://travis-ci.org/59naga/jasminetea.svg?branch=master
[travis]: https://travis-ci.org/59naga/jasminetea
[coveralls-image]: https://coveralls.io/repos/59naga/jasminetea/badge.svg?branch=master
[coveralls]: https://coveralls.io/r/59naga/jasminetea?branch=master


[1]: http://jasmine.github.io/2.3/introduction.html
[2]: http://coffeescript.org/
[3]: https://nodejs.org/