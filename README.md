# ![jasminetea][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> CLI Collection, Getting quick-started of jasmine[d-1].

1. Without configuration file
2. Can be running spec. by [jasmine-node][d-1]
3. Can be calculate code caverage. by [iblik][d-2]
4. Can be checking code quality. by [coffeelint][d-3]
5. for [CoffeeScript][d-4]

## Installation
```bash
$ npm install jasminetea
```

[Can be worked in package.json scripts.][1] e.g. (`$ npm start` > "jasminetea test -r")

## CLI
```bash
#  Usage: jasminetea specDir [options...]
#
#  Options:
#
#    -h, --help           output usage information
#    -V, --version        output the version number

#    -r --recursive       Execute specs in recursive directory
#    -w --watch [globs]   Watch file changes. Refer \[globs\] (can use "," separator)
#    -c --cover           Use ibrik, Code coverage calculation

#    -v --verbose         Output spec names
#    -t --timeout <msec>  Success time-limit <500>
#    -s --stacktrace      Output stack trace

#    -l --lint [globs]    Use coffeelint, Code linting after success. Refer \[globs\] (can use "," separator)
```

`--watch`,`--lint` Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"`

## Example
```bash
jasminetea test -r -w
# Found 0 files by test/**/*[sS]pec.js or test/**/*[sS]pec.coffee ...
# Running 0 specs.
# 
# 
# 0 specs, 0 failures
# Finished in 0 seconds
# Wathing files by *.coffee or lib/**/*.coffee or test/**/*.coffee ...
```

### More Example

#### Use `-c` [iblik][d-2]

```bash
jasminetea . -c
#
# Found 1 files by *[sS]pec.js or *[sS]pec.coffee ...
# ..........
# 
# 10 specs, 0 failures
# Finished in 0 seconds
# =============================================================================
# Writing coverage object [./coverage/coverage.json]
# Writing coverage reports at [./coverage]
# =============================================================================
# 
# =============================== Coverage summary ===============================
# Statements   : 73.98% ( 182/246 )
# Branches     : 50% ( 39/78 )
# Functions    : 81.82% ( 45/55 )
# Lines        : 81.16% ( 112/138 )
# ================================================================================
```

#### Use `-l` [coffeelint][d-3]

```bash
jasminetea . -l
# 
# Found 1 files by *[sS]pec.js or *[sS]pec.coffee ...
# ..........
# 
# 10 specs, 0 failures
# Finished in 0 seconds
# 
# Next, linting by lib/*.coffee or *.coffee ...
#   ✗ jasminetea.coffee
#      ✗ #7: Line exceeds maximum allowed length. Length is 94, max is 80.
#      ✗ #14: Line exceeds maximum allowed length. Length is 117, max is 80.
#      ✗ #31: Line exceeds maximum allowed length. Length is 82, max is 80.
#   ✗ jasminetea.spec.coffee
#      ✗ #107: Line exceeds maximum allowed length. Length is 100, max is 80.
# 
# ✗ Lint! » 4 errors and 0 warnings in 2 files
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
[d-4]: http://coffeescript.org/

[1]: http://www.jayway.com/2014/03/28/running-scripts-with-npm/