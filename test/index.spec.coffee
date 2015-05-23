CLI= (require '../src').Jasminetea

# Fixture
$jasminetea= (args,exec=on)->
  stdout= ''
  reporter= (string)->
    stdout+= string

  argv= ['node',__filename]
  for arg in args.match /".*?"|[^\s]+/g
    argv.push arg.replace /^"|"$/g,''

  cli= new CLI
  cli.silent= on
  cli.parse argv,reporter,exec
  cli.debug= on

  [cli,reporter]

# Specs
describe 'CLI',->
  describe '@parse',->
    it '$ jasminetea test -> test/*[sS]pec.coffee (watch to . src test)',->
      [cli,reporter]=
        $jasminetea 'test',off

      expect(cli.specs).toEqual ['test/*[sS]pec.coffee']
      expect(cli.scripts).toEqual ['*.coffee','src/*.coffee','test/*.coffee']

    it '$ jasminetea test -w wuck -rvscd -f fuck -t 59798 --report -l luck (all true)',->
      [cli,reporter]=
        $jasminetea 'test -w wuck -rvscd -f fuck -t 59798 --report -l luck',off

      expect(cli.specs).toEqual ['test/**/fuck']
      expect(cli.scripts).toEqual ['*.coffee','src/**/*.coffee','test/**/*.coffee']
      expect(cli.watch).toEqual ['wuck']
      expect(cli.file).toBe 'fuck'
      expect(cli.verbose).toBe true
      expect(cli.stacktrace).toBe true
      expect(cli.timeout).toBe '59798'
      expect(cli.cover).toBe true
      expect(cli.report).toBe true
      expect(cli.lint).toEqual ['luck']
      expect(cli.debug).toBe true