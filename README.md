# ![jasminetea][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> CLI Collection, Quick start [jasmine][d-1] for [CoffeeScript][d-5].

1. Without configuration file
2. Can be running spec. by [jasmine-node][d-1]
3. Can be calculate code caverage. by [iblik][d-2]
4. Can be checking code quality. by [coffeelint][d-3]
4. Can be running spec for e2e. by [protractor][d-4]
5. for [CoffeeScript][d-5]

## Installation
```bash
$ npm install jasminetea
```

[Can be worked in package.json scripts.][1] e.g. (`$ npm start` > scripts:start(package.json) > "jasminetea test -r")

or
```
$ npm install jasminetea --global
```
Enable `jasminetea specDir` commands. then can immediately run.

## CLI
```bash
#   Usage: jasminetea specDir [options...]
# 
#   7_P
# 
#   Options:
# 
#     -r --recursive        Execute specs in recursive directory
#     -v --verbose          Output spec names
#     -s --stacktrace       Output stack trace
#     -t --timeout <msec>   Success time-limit <1000>msec
#
#     -w --watch [globs]    Watch file changes. Refer [globs] (can use "," separator)
#     -c --cover            Use ibrik, Code coverage calculation
#     -l --lint [globs]     Use coffeelint, Code linting after run. Refer [globs] (can use "," separator)
#
#     -e --e2e [==arg ...]  Use protractor, Change to the E2E test mode
#     -d --debug            Output raw commands $ for -c,-l,-e
```

`--watch`,`--lint` Default `"spec_dir/*.coffee,lib/**/*.coffee,*.coffee"`

## Example
```bash
jasminetea hoge -r -w
# 7_P Spec Notfound. by **/*[sS]pec.js or **/*[sS]pec.coffee
# 
# 
# 0 specs, 0 failures
# Finished in 0 seconds
# 7_P Watching files by *.coffee or lib/**/*.coffee or hoge/**/*.coffee ...
```

### More Example

#### Use `-c` [iblik][d-2]

```bash
jasminetea test -c

# 7_P Found 1 files by test/*[sS]pec.js or test/*[sS]pec.coffee ...
# Running 4 specs.
# 
# Server
#   /Users/59naga/Downloads/jasminetea/test/fixtures
#       Default current files: passed
#       Use -rwcvtsl Fullstack.: passed
# Client
#   /Users/59naga/Downloads/jasminetea/test/fixtures
#       Default current files: passed
#       Use -rwcvtsl Fullstack.: passed
# 
# 4 specs, 0 failures
# Finished in 0 seconds
# =============================================================================
# Writing coverage object [/Users/59naga/Downloads/jasminetea/coverage/coverage.json]
# Writing coverage reports at [/Users/59naga/Downloads/jasminetea/coverage]
# =============================================================================
# 
# =============================== Coverage summary ===============================
# Statements   : 36.13% ( 112/310 )
# Branches     : 24.64% ( 34/138 )
# Functions    : 36.54% ( 19/52 )
# Lines        : 40.63% ( 65/160 )
# ================================================================================
```

#### Use `-l` [coffeelint][d-3]

```bash
jasminetea . -l
# 7_P Spec Notfound. by *[sS]pec.js or *[sS]pec.coffee
# 
# 
# 0 specs, 0 failures
# Finished in 0 seconds
# 
# 7_P Lint by lib/*.coffee or *.coffee ...
#   ✗ jasminetea.coffee
#      ✗ #5: Line exceeds maximum allowed length. Length is 89, max is 80.
#      ✗ #13: Line exceeds maximum allowed length. Length is 94, max is 80.
#      ✗ #15: Line exceeds maximum allowed length. Length is 113, max is 80.
#      ...
# 
# ✗ Lint! » 15 errors and 0 warnings in 1 file
```

#### Use `-e` [protractor][d-4]

`npm install forever node-static` after:

```bash
forever start $(npm bin)/static test && jasminetea test -e '==baseUrl http://127.0.0.1:8080/'
# 7_P Found 1 files by test/*[sS]pec.js or test/*[sS]pec.coffee ...
# Running 2 specs.
# 
#   /Users/59naga/Downloads/jasminetea/test/fixtures
#       Default current files: passed
#       Use -rwcvtsl Fullstack.: passed
# 
# 2 specs, 0 failures
# Finished in 0 seconds
```

# TODO
* Refactoring (really dirty...)

License
=========================
MIT by 59naga

[.svg]: https://cdn.rawgit.com/59naga/jasminetea/master/.svg

[npm-image]: https://badge.fury.io/js/jasminetea.svg
[npm]: https://npmjs.org/package/jasminetea
[travis-image]: https://travis-ci.org/59naga/jasminetea.svg?branch=master
[travis]: https://travis-ci.org/59naga/jasminetea
[coveralls-image]: https://coveralls.io/repos/59naga/jasminetea/badge.svg?branch=master
[coveralls]: https://coveralls.io/r/59naga/jasminetea?branch=master

[d-1]: https://github.com/mhevery/jasmine-node
[d-2]: https://github.com/Constellation/ibrik
[d-3]: http://coffeelint.org/
[d-4]: http://angular.github.io/protractor/
[d-5]: http://coffeescript.org/

[1]: http://www.jayway.com/2014/03/28/running-scripts-with-npm/
