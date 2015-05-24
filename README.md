# ![jasminetea][.svg] jasminetea [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> CLI Collection, Quick start [Jasmine2][d-1] for [CoffeeScript][d-4].

1. Without configuration file
2. Can be running spec. by [Jasmine2][d-1]
3. Can be calculate code caverage. by [iblik][d-2]
4. Can be checking code quality. by [coffeelint][d-3]
5. for [CoffeeScript][d-4]

[d-1]: https://github.com/jasmine/jasmine
[d-2]: https://github.com/Constellation/ibrik
[d-3]: http://coffeelint.org/
[d-4]: http://coffeescript.org/

## Installation
```bash
$ npm install jasminetea --global
$ jasminetea -V
# 0.2.0

$ jasminetea
#
#   Usage: jasminetea specDir [options...]
#
#   Options:
#
#     -h, --help            output usage information
#     -V, --version         output the version number
#     -c --cover            Use ibrik, Code coverage calculation
#     --report              Use coveralls, Post code coverage to coveralls.io
#     -l --lint [globs]     Use coffeelint, Code linting after run. See [globs] (can use "," separator)
#     -w --watch [globs]    Watch file changes. See [globs] (can use "," separator)
#     -f --file [specGlob]  Target [specGlob] (default "*[sS]pec.coffee")
#     -r --recursive        Execute specs in recursive directory
#     -v --verbose          Output spec names
#     -s --stacktrace       Output stack trace
#     -t --timeout <msec>   Success time-limit (default 500 msec)
#     -d --debug            Output raw commands
```

# Quick start
```bash
$ jasminetea test --cover --report --lint --watch
#  7_P +133 ms Spec not exists in test/*[sS]pec.coffee
# 
# 
# 
# 0 specs, 0 failures
# Finished in 0 seconds
# 
#  7_P   +2 ms Skip --cover.  Because not exists in test/*[sS]pec.coffee
#  7_P   +7sec Skip --report. Because not exists the COVERALLS_REPO_TOKEN
#  7_P   +2 ms Skip --lint.   Because not exists in *.coffee or src/*.coffee or test/*.coffee
#  7_P   +0 ms Watching the *.coffee and src/*.coffee and test/*.coffee ...
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