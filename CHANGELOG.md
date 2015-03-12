v0.1.23 / Mar 13 2015
=========================
 * [`unknown`][unknown] :coffee: Add `-f` `--file` option, Can change target spec glob.


v0.1.22 / Mar 11 2015
=========================
 * [`e68e514`][e68e514] :bug: reFix process.exit(0) due to failed spec (via --cover)
 * [`2edc63b`][2edc63b] :bug: Fix: Ignored jasmine options

[e68e514]: https://github.com/59naga/jasminetea/commit/e68e514efd29d902ccd0d6655ae736af05f3031e
[2edc63b]: https://github.com/59naga/jasminetea/commit/2edc63bb92eb50daf18bfbd94c7cf93469e73870

v0.1.20 / Mar 08 2015
=========================
 * [`e3a5225`][e3a5225] :bug: Fix `--e2e` protractor cli multiple param parsing
 * [`e3a5225`][e3a5225] :bug: Fix `--debug` webdriver stdio inheriting
 * [`932af17`][932af17] :coffee: Rehotfix: conflict by iblik>coffee-script/rergister v1.8.0
 * [`159940a`][159940a] :coffee: Without *[sS]pec.js
 * [`6a34e1e`][6a34e1e] :green_heart: add `--report` Reporting code coverage to coveralls.io
 * [`5e77347`][5e77347] :bug: Fix `--e2e` printing spec results
 * [`5e77347`][5e77347] :bug: Hotfix process.exit(__0__) due to failed spec

[e3a5225]: https://github.com/59naga/jasminetea/commit/e3a52257e82525eb23388fc58b4b1bd9602e3b29
[932af17]: https://github.com/59naga/jasminetea/commit/932af1739302eadbb46009177d3bf7f49483e823
[159940a]: https://github.com/59naga/jasminetea/commit/159940a69ad0bc23c4c1d854119b48cf2815d9d6
[6a34e1e]: https://github.com/59naga/jasminetea/commit/6a34e1ec8f50937933f2f9ab9ad44a304fa02c7c
[5e77347]: https://github.com/59naga/jasminetea/commit/5e77347558ec0769ea7b1fd22ec4dcbe921308c9

v0.1.13 / Mar 07 2015
=========================
 * [`8e5ae63`][8e5ae63] :sushi: Add `-e` `--e2e` the protractor option
 * [`8e5ae63`][8e5ae63] :exclamation: Deprecated `-p` `--protractor` option
 * [`8e5ae63`][8e5ae63] :clock7: Change default: Success time-limit _500_ to _1000_ msec(for e2e)

[8e5ae63]: https://github.com/59naga/jasminetea/commit/8e5ae63640ddc5614ace5e12e2e4d9e38a8f6ceb

v0.1.10 / Mar 06 2015
=========================
 * [`0fa3599`][0fa3599] :lipstick: Without dependency `gulp*` after with `[chokidar][1]`,`[wanderer][2]` and `[jasmine-node][3]`
 * [`0fa3599`][0fa3599] :lipstick: Change `jasminetea` default `test -r`
 * [`0fa3599`][0fa3599] :bug: Fix `--watch` conflict `--cover` and `--lint`

[0fa3599]: https://github.com/59naga/jasminetea/commit/0fa3599a53e88a18c1fcaebcb9b44ed5ded92026

[1]: https://github.com/paulmillr/chokidar
[2]: https://github.com/59naga/wanderer
[3]: https://github.com/mhevery/jasmine-node

v0.1.9 / Mar 05 2015
=========================
 * [`f7cefa2`][f7cefa2] :bug: Fix Not reported throw error

[f7cefa2]: https://github.com/59naga/jasminetea/commit/f7cefa2be1bf27f27b8feec815f5ed8e3e66dc46

v0.1.8 / Mar 04 2015
=========================
 * [`50cc0df`][50cc0df] Change `--watch` without required value. (e.g. <globs> -> [globs])
    Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"`
 * [`50cc0df`][50cc0df] Change `--lint` without required value. (e.g. <globs> -> [globs])
    Default `"spec_dir/*.coffee,lib/**/*.coffee,.*.coffee"`

[50cc0df]: https://github.com/59naga/jasminetea/commit/50cc0df352a9773c796bcfeba6e8d27fa5cabf00


v0.1.7 / Mar 03 2015
=========================
 * [`74a969a`][74a969a] Add `--cover` --cover Code coverage calculation option by [ibrik][1]
 * [`6a13e95`][6a13e95] Dependencies update

[74a969a]: https://github.com/59naga/jasminetea/commit/74a969a3b5cdf7d7e67aab200b4add65638a7791
[6a13e95]: https://github.com/59naga/jasminetea/commit/6a13e95593bf3ca960bed7ecb5a0f43ebe8124e0

v0.1.6 / Mar 02 2015
=========================
 * [`bdd2edb`][bdd2edb] Up `node-module-all` to v0.0.5
 * [`6e3bf04`][6e3bf04] Fix `-g` test
 * [`f3db200`][f3db200] Change `jasminetea` for codegolf

[bdd2edb]: https://github.com/59naga/node-module-all/commit/bdd2edb0664420a011c6b4d1bf92e9cc61974ac3
[6e3bf04]: https://github.com/59naga/jasminetea/commit/6e3bf04bf233459e632e3cfde8fb7d638f0ae347
[f3db200]: https://github.com/59naga/jasminetea/commit/f3db2008c93f30cac4d365fa341350643e7c2679

[1]: https://github.com/Constellation/ibrik

[unknown]: https://github.com/59naga/jasminetea/commit/