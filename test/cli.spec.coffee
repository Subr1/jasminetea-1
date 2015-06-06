# Dependencies
equal= (require 'power-assert').equal
CLI= (require '../src').Jasminetea

# Fixture
$jasminetea= (argvString)->
  argv= ['node',__filename]

  args= argvString.match /".*?"|[^\s]+/g
  args?= []
  for arg in args
    argv.push arg.replace /^"|"$/g,''

  cli= new CLI
  cli.test= yes
  cli.parse argv

  cli

# Specs
describe 'CLI',->
  beforeEach -> delete process.env.JASMINETEA

  describe '@parse',->
    it '$ jasminetea',->
      cli=
        $jasminetea ''

      equal cli.specs[0], 'test/*[sS]pec.coffee'

      equal cli.scripts[0], '*.coffee'
      equal cli.scripts[1], 'src/*.coffee'
      equal cli.scripts[2], 'test/*.coffee'

    it '$ jasminetea test',->
      cli=
        $jasminetea 'test'

      equal cli.specs[0], 'test/*[sS]pec.coffee'
      
      equal cli.scripts[0], '*.coffee'
      equal cli.scripts[1], 'src/*.coffee'
      equal cli.scripts[2], 'test/*.coffee'

    it '$ jasminetea test -w foo -rSscd -f bar -t 59798 --report -l baz',->
      cli=
        $jasminetea 'test -w foo -rSscd -f bar -t 59798 --report -l baz'

      equal cli.specs[0], 'test/**/bar'
      equal cli.scripts[0], '*.coffee'
      equal cli.scripts[1], 'src/**/*.coffee'
      equal cli.scripts[2], 'test/**/*.coffee'
      
      equal cli.watch[0], 'foo'
      equal cli.file, 'bar'
      equal cli.silent, true
      equal cli.stacktrace, true
      equal cli.timeout, '59798'
      equal cli.cover, true
      equal cli.report, true
      equal cli.lint[0], 'baz'
      equal cli.debug, true
