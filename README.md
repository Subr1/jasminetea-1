# ![jasminetea][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> CLI Collection, Quick start [Jasmine2][d-1] for [CoffeeScript][d-5].

1. Without configuration file
2. Can be running spec. by [Jasmine2][d-1]
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
# Usage: jasminetea specDir [options...]
#
#   7_P
# 
#   Options:
# 
#     -h, --help              output usage information
#     -V, --version           output the version number
#     -r --recursive          Execute specs in recursive directory
#     -v --verbose            Output spec names
#     -s --stacktrace         Output stack trace
#     -t --timeout <msec>     Success time-limit (default 1000 msec)
#
#     -f --file [specGlob]    Target [specGlob] (default "*[sS]pec.coffee")
#     -w --watch [globs]      Watch file changes. See [globs] (can use "," separator)
#
#     -c --cover              Use ibrik, Code coverage calculation
#     --report                Use coveralls, Reporting code coverage to coveralls.io
#     -l --lint [globs]       Use coffeelint, Code linting after run. See [globs] (can use "," separator)
#     -e --e2e [==param ...]  Use protractor, Change to the E2E test mode
#
#     -d --debug              Output raw commands and stdout $ for --cover,--lint,--e2e
```

`--watch`,`--lint` Default see `"spec_dir/*.coffee,src/**/*.coffee,*.coffee"`

## Example
```bash
jasminetea test --cover --report
# 7_P Found 3 files by test/*[sS]pec.coffee ...
# Running 27 specs.
# ...........................
# 
# 27 specs, 0 failures, 4 pending specs
# Finished in 0 seconds
# 
# 7_P Calculating...
# =============================================================================
# Writing coverage object [/Users/59naga/Downloads/jasminetea/coverage/coverage.json]
# Writing coverage reports at [/Users/59naga/Downloads/jasminetea/coverage]
# =============================================================================
# 
# =============================== Coverage summary ===============================
# Statements   : 63.95% ( 314/491 )
# Branches     : 35.65% ( 77/216 )
# Functions    : 70.42% ( 50/71 )
# Lines        : 65.31% ( 160/245 )
# ================================================================================
# 7_P Skip post a coverage report. Cause not exists COVERALLS_REPO_TOKEN
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

[d-1]: https://github.com/jasmine/jasmine
[d-2]: https://github.com/Constellation/ibrik
[d-2-1]: https://github.com/cainus/node-coveralls#istanbul
[d-2-2]: http://docs.travis-ci.com/user/environment-variables/
[d-3]: http://coffeelint.org/
[d-4]: http://angular.github.io/protractor/
[d-5]: http://coffeescript.org/

[1]: http://www.jayway.com/2014/03/28/running-scripts-with-npm/
