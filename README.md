# ![jasminetea][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> is CLI of [gulp-jasmine][1] for [CoffeeScript][2]

1. without -g install
2. without jasmine.json
3. self-contained CLI
4. for CoffeeScript

## Installation
```bash
$ npm install jasminetea
```

[Can be worked in package.json scripts.][3] e.g. (`$ npm start` > "jasminetea test -r")

## CLI
```bash
# Usage: jasminetea spec_dir [options...]

# Options:

# -h, --help           output usage information
# -V, --version        output the version number

# -r --recursive       Execute specs in recursive directory
# -w --watch <globs>   Watch file changes by <globs> (can use "," # separator)
# -c --cover           Use ibrik, Code coverage calculation

# -v --verbose         Output spec names
# -t --timeout <msec>  Success time-limit <500 msec>
# -s --stacktrace      Output stack trace

# -l --lint <globs>    Use coffeelint, Code linting after success
```

## Example
```bash
jasminetea test -r -w "test/**/*.coffee,lib/**/*.coffee"`
# Found 0 files by test/*[sS]pec.js or test/*[sS]pec.coffee ...
# Running 0 specs.
# 
# 
# 0 specs, 0 failures
# Finished in 0 seconds
# Wathing files by test/**/*.coffee or lib/**/*.coffee ...
```

### More Example

#### Use `-l` [coffeelint][4]

```bash
jasminetea . -l \"*.coffee\"

# Found 0 files by *[sS]pec.js or *[sS]pec.coffee ...
# Running 0 specs.
#
#
# 0 specs, 0 failures
# Finished in 0 seconds
# Next, linting ...
#   ✗ jasminetea.coffee
#      ✗ #7: Line exceeds maximum allowed length. Length is 95, max is 80.
#      ✗ #15: Line exceeds maximum allowed length. Length is 100, max is 80.
#      ✗ #20: Line exceeds maximum allowed length. Length is 91, max is 80.
#      ✗ #26: Line ends with trailing whitespace.
#      ✗ #80: Line exceeds maximum allowed length. Length is 90, max is 80.
#
# ✗ Lint! » 5 errors and 0 warnings in 1 file
#
# Linted from *.coffee
```

#### Use `-c` [iblik][5]

```bash
jasminetea . -c

# Found 1 files by *[sS]pec.js or *[sS]pec.coffee ...
# FFFFFFFF.
# 
# Failures:
# 
# 9 specs, 8 failures
# Finished in 0 seconds
# =============================================================================
# Writing coverage object [/Users/59naga/Downloads/jasminetea/coverage/coverage.json]
# Writing coverage reports at [/Users/59naga/Downloads/jasminetea/coverage]
# =============================================================================
# 
# =============================== Coverage summary ===============================
# Statements   : 63.64% ( 147/231 )
# Branches     : 42.59% ( 23/54 )
# Functions    : 74.07% ( 40/54 )
# Lines        : 66.67% ( 80/120 )
# ================================================================================
```

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

[1]: https://github.com/sindresorhus/gulp-jasmine
[2]: http://coffeescript.org/
[3]: http://www.jayway.com/2014/03/28/running-scripts-with-npm/
[4]: http://coffeelint.org/
[5]: https://github.com/Constellation/ibrik