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

      expect(cli.specs).toEqual ['test/*[sS]pec.coffee']
      expect(cli.scripts).toEqual ['*.coffee','src/*.coffee','test/*.coffee']

    it '$ jasminetea test',->
      cli=
        $jasminetea 'test'

      expect(cli.specs).toEqual ['test/*[sS]pec.coffee']
      expect(cli.scripts).toEqual ['*.coffee','src/*.coffee','test/*.coffee']

    it '$ jasminetea test -w foo -rSscd -f bar -t 59798 --report -l baz',->
      cli=
        $jasminetea 'test -w foo -rSscd -f bar -t 59798 --report -l baz'

      expect(cli.specs).toEqual ['test/**/bar']
      expect(cli.scripts).toEqual ['*.coffee','src/**/*.coffee','test/**/*.coffee']
      expect(cli.watch).toEqual ['foo']
      expect(cli.file).toBe 'bar'
      expect(cli.silent).toBe true
      expect(cli.stacktrace).toBe true
      expect(cli.timeout).toBe '59798'
      expect(cli.cover).toBe true
      expect(cli.report).toBe true
      expect(cli.lint).toEqual ['baz']
      expect(cli.debug).toBe true