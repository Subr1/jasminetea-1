# ![][.svg] Jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

```
            {
         }   }   {
        {   {  }  }
         }   }{  {
        {  }{  }  }          
       { }{ }{  { }          
     .- { { }  { }} -.       
    (  { } { } { } }  )      
    |`-..________ ..-'|      
    |                 |      
    |                 ;--.   
    |        ___      (__  \         _            _             
    |       |_  |      | )  )       (_)          | |            
    |         | | __ _ ___ _ __ ___  _ _ __   ___| |_ ___  __ _ 
    |         | |/ _` / __| '_ ` _ \| | '_ \ / _ \ __/ _ \/ _` |
    |     /\__/ / (_| \__ \ | | | | | | | | |  __/ ||  __/ (_| |
    |     \____/ \__,_|___/_| |_| |_|_|_| |_|\___|\__\___|\__,_|
     `-.._________..    
```

> is [Jasmine2](http://jasmine.github.io/2.3/introduction.html) using [CoffeeScript](http://coffeescript.org/) in Node.js

## Getting started
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

# More commands

## `--lint`, `-l`

Check the code quality in `*.coffee` and `src/*.coffee` and `test/*.coffee` After the test. by [CoffeeLint](https://github.com/clutchski/coffeelint).
Use `.coffeelintrc` as config if exists current working directory.
If change the subject then Type the glob separated by commas After the `--lint`.

Example:

```bash
$ jasminetea --lint
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Lint in *.coffee and src/*.coffee and test/*.coffee ...
# ...
# ✓ Ok! » 0 errors and 0 warnings in 8 files

$ jasminetea --lint foo/bar/baz/**/*.spec.coffee
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Skip --lint.   Because not exists in foo/bar/baz/**/*.spec.coffee
```

## `--cover`, `-c`

Calculate the [code coverage](http://en.wikipedia.org/wiki/Code_coverage) in `src` After the test. by [Ibrik](https://github.com/59naga/ibrik)

```bash
$ jasminetea --cover
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Calculating...
# =============================================================================
# Writing coverage object [/Users/59naga/Downloads/jasminetea/coverage/coverage.json]
# Writing coverage reports at [/Users/59naga/Downloads/jasminetea/coverage]
# =============================================================================
# 
# =============================== Coverage summary ===============================
# Statements   : 88.65% ( 336/379 )
# Branches     : 64.84% ( 83/128 )
# Functions    : 88.57% ( 62/70 )
# Lines        : 92.75% ( 179/193 )
# ================================================================================
```

Also, Can post the coverage report to [coveralls.io](https://coveralls.io/) If use `--report`
Need to beforehand set the COVERALLS_REPO_TOKEN in environment or .coveralls.yml

```bash
$ export COVERALLS_REPO_TOKEN=my_coveralls_repo_token
$ jasminetea --cover --report
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Calculating...
# ...
# 7_P    +6s Posted a coverage report.
```

The process exits with __code 1__ if test failing or no specs found.

```bash
$ jasminetea unknown/directory --cover && echo "success" || echo "failure"
# 7_P +206ms Spec not exists in unknown/directory/*[sS]pec.coffee
# 7_P   +3ms Skip --cover.  Because not exists in unknown/directory/*[sS]pec.coffee
# failure
```

## `-w`, `--watch`
Monitor changes in `*.coffee` and `src/*.coffee` and `test/*.coffee` after the above commands if use option.
Re-execution the jasminetea if has been changed in globs.
If change the subject then Type the glob separated by commas After the `--watch`.

```bash
$ jasminetea --watch
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Lint in *.coffee and src/*.coffee and test/*.coffee ...
# ...
# 7_P    +1s Watch in *.coffee and src/*.coffee and test/*.coffee ...

$ jasminetea --watch foo/bar/baz/**/*.spec.coffee
# 7_P +182ms Found 4 files in test/*[sS]pec.coffee ...
# ...
# 7_P    +1s Watch in foo/bar/baz/**/*.spec.coffee ...
```

# Other options
See `$ jasminetea --help`

```bash
#
#  Usage: jasminetea [specDir] [options...]
#
#  Options:
#
#    -h, --help            output usage information
#    -V, --version         output the version number
#    -c --cover            Use ibrik, Code coverage calculation
#    --report              Send lcov.info to coveralls.io via --cover
#    -l --lint [globs]     Use .coffeelintrc, Code linting after run. Find in [globs] (can use "," separator)
#    -w --watch [globs]    Watch file changes. See [globs] (can use "," separator)
#    -f --file [specGlob]  Target [specGlob] (default "*[sS]pec.coffee")
#    -r --recursive        Search to recursive directory
#    -S --silent           Use dots reporter
#    -s --stacktrace       Output stack trace
#    -t --timeout <msec>   Success time-limit (default 500 msec)
#    -d --debug            Output raw commands
#
```

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
