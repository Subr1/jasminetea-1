# jasminetea
is CLI of [gulp-jasmine](https://github.com/sindresorhus/gulp-jasmine)

## Installation
```bash
$ npm install jasminetea -g
```

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
