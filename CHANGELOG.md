v0.1.28 / May 14 2015
=========================
 * [`unknown`][22] :bug: Fix [#4][22A]
 * [`unknown`][23] Change `--watch`,`--lint` Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"` to `"spec_dir/*.coffee,src/**/*.coffee,.*.coffee"`
 * [`unknown`][24] :bug: Fix [#2][24A]

[22]: https://github.com/59naga/jasminetea/commit/7030d81c79c2e1405193c7455a121f2f17a35467
[22A]: https://github.com/59naga/jasminetea/issues/4
[23]: https://github.com/59naga/jasminetea/commit/649663a301a33f124f7c93b4cb79ce1d17da2d66
[24]: https://github.com/59naga/jasminetea/commit/
[24A]: https://github.com/59naga/jasminetea/issues/2

v0.1.27 / Mar 29 2015
=========================
 * [`d71ca28`][21] :arrow_up: +protractor@2.0.0

[21]: https://github.com/59naga/jasminetea/commit/d71ca285f9e0f93baf435e7709273d13ceb9680e

v0.1.26 / Mar 14 2015
=========================
 * [`13b207f`][20] :bug: Fix conflict of `--watch` and `--e2e`
 * [`13b207f`][20] :fire: Remove webdriverStart

[20]: https://github.com/59naga/jasminetea/commit/13b207faa07a080e3632a2ff9e6f8a171f82071d

v0.1.25 / Mar 13 2015
=========================
 * [`0a76d20`][18] :bug: Fix `--cover`'s `No coverage information was collected, exit without writing coverage information` by `--e2e`&`--cover`
 * [`0a76d20`][18] :bug: Fix `--e2e`'s Duplicate webdriver launch
 * [`0a76d20`][18] :fire: Remove collection.webdriverKill & config.seleniumKillAddress
 * [`4de6058`][19] :bug: Fix initial webdriverUpdate by `--e2e`&`--cover`

[18]: https://github.com/59naga/jasminetea/commit/0a76d20e0c50e36d6e613576b68d53251f995fb0
[19]: https://github.com/59naga/jasminetea/commit/4de60586b1619ae8e9b54d96c0f18f027ba9d6d2

v0.1.23 / Mar 13 2015
=========================
 * [`3415806`][17] :coffee: Add `-f` `--file` option, Can change target spec glob.

[17]: https://github.com/59naga/jasminetea/commit/3415806b39226adc6e8d8622ec2420f25c2863fc#diff-67d0ac7f02a12f93fe738f53eed7d485L34

v0.1.22 / Mar 11 2015
=========================
 * [`e68e514`][15] :bug: reFix process.exit(0) due to failed spec (via --cover)
 * [`2edc63b`][16] :bug: Fix: Ignored jasmine options

[15]: https://github.com/59naga/jasminetea/commit/e68e514efd29d902ccd0d6655ae736af05f3031e
[16]: https://github.com/59naga/jasminetea/commit/2edc63bb92eb50daf18bfbd94c7cf93469e73870

v0.1.20 / Mar 08 2015
=========================
 * [`e3a5225`][10] :bug: Fix `--e2e` protractor cli multiple param parsing
 * [`e3a5225`][10] :bug: Fix `--debug` webdriver stdio inheriting
 * [`932af17`][11] :coffee: Rehotfix: conflict by iblik>coffee-script/rergister v1.8.0
 * [`159940a`][12] :coffee: Without *[sS]pec.js
 * [`6a34e1e`][13] :green_heart: add `--report` Reporting code coverage to coveralls.io
 * [`5e77347`][14] :bug: Fix `--e2e` printing spec results
 * [`5e77347`][14] :bug: Hotfix process.exit(__0__) due to failed spec

[10]: https://github.com/59naga/jasminetea/commit/e3a52257e82525eb23388fc58b4b1bd9602e3b29
[11]: https://github.com/59naga/jasminetea/commit/932af1739302eadbb46009177d3bf7f49483e823
[12]: https://github.com/59naga/jasminetea/commit/159940a69ad0bc23c4c1d854119b48cf2815d9d6
[13]: https://github.com/59naga/jasminetea/commit/6a34e1ec8f50937933f2f9ab9ad44a304fa02c7c
[14]: https://github.com/59naga/jasminetea/commit/5e77347558ec0769ea7b1fd22ec4dcbe921308c9

v0.1.13 / Mar 07 2015
=========================
 * [`8e5ae63`][09] :sushi: Add `-e` `--e2e` the protractor option
 * [`8e5ae63`][09] :exclamation: Deprecated `-p` `--protractor` option
 * [`8e5ae63`][09] :clock7: Change default: Success time-limit _500_ to _1000_ msec(for e2e)

[09]: https://github.com/59naga/jasminetea/commit/8e5ae63640ddc5614ace5e12e2e4d9e38a8f6ceb

v0.1.10 / Mar 06 2015
=========================
 * [`0fa3599`][08] :lipstick: Without dependency `gulp*` after with `[chokidar][1]`,`[wanderer][2]` and `[jasmine-node][3]`
 * [`0fa3599`][08] :lipstick: Change `jasminetea` default `test -r`
 * [`0fa3599`][08] :bug: Fix `--watch` conflict `--cover` and `--lint`

[08]: https://github.com/59naga/jasminetea/commit/0fa3599a53e88a18c1fcaebcb9b44ed5ded92026

v0.1.9 / Mar 05 2015
=========================
 * [`f7cefa2`][07] :bug: Fix Not reported throw error

[07]: https://github.com/59naga/jasminetea/commit/f7cefa2be1bf27f27b8feec815f5ed8e3e66dc46

v0.1.8 / Mar 04 2015
=========================
 * [`50cc0df`][06] Change `--watch` without required value. (e.g. <globs> -> [globs])
    Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"`
 * [`50cc0df`][06] Change `--lint` without required value. (e.g. <globs> -> [globs])
    Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"`

[06]: https://github.com/59naga/jasminetea/commit/50cc0df352a9773c796bcfeba6e8d27fa5cabf00


v0.1.7 / Mar 03 2015
=========================
 * [`74a969a`][04] Add `--cover` --cover Code coverage calculation option by [ibrik][1]
 * [`6a13e95`][05] Dependencies update

[04]: https://github.com/59naga/jasminetea/commit/74a969a3b5cdf7d7e67aab200b4add65638a7791
[05]: https://github.com/59naga/jasminetea/commit/6a13e95593bf3ca960bed7ecb5a0f43ebe8124e0

v0.1.6 / Mar 02 2015
=========================
 * [`bdd2edb`][01] Up `node-module-all` to v0.0.5
 * [`6e3bf04`][02] Fix `-g` test
 * [`f3db200`][03] Change `jasminetea` for codegolf

[01]: https://github.com/59naga/node-module-all/commit/bdd2edb0664420a011c6b4d1bf92e9cc61974ac3
[02]: https://github.com/59naga/jasminetea/commit/6e3bf04bf233459e632e3cfde8fb7d638f0ae347
[03]: https://github.com/59naga/jasminetea/commit/f3db2008c93f30cac4d365fa341350643e7c2679

[01]: https://github.com/Constellation/ibrik

[00]: https://github.com/59naga/jasminetea/commit/