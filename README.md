# jasminetea
is CLI of [gulp-jasmine](https://github.com/sindresorhus/gulp-jasmine)

1. without -g install
2. without jasmine.json
3. self-contained CLI
4. for CoffeeScript

## Installation
```bash
$ npm install jasminetea
```

[Can be worked in package.json scripts.][1] e.g. (`npm start > "jasminetea test -r"`)

## CLI
`jasminetea spec_dir [options...]`

## CLI Options
```bash
  Usage: jasminetea spec_dir [options...]

  Options:

    -h, --help         output usage information
    -V, --version      output the version number

    -r recursive       Execute specs in recursive directory
    -w watch <globs>   Watch globs changes (can use "," separator)
    
    -v verbose         Output spec names
    -s stacktrace      Output stack trace
    -t timeout <msec>  Success time-limit <500 msec>
```

## Example
```bash
jasminetea test -r -w "test/**/*.coffee,lib/**/*.coffee"`
Running 0 specs.


0 specs, 0 failures
Finished in 0 seconds
Wathing files by test/**/*.coffee or lib/**/*.coffee ...
```

## Feture
**TEST**

## License
MIT by 59naga

[1]: http://www.jayway.com/2014/03/28/running-scripts-with-npm/
