## 0.5.0 - June 2, 2012

### Bug fix:

- [#24](https://github.com/guard/guard-test/issues/24): Add note for Rails projects using profile/benchmark tests in README. ([@coderjoe][])

### Changes:

- Updated for Guard 1.1

### New feature:

- [#20](https://github.com/guard/guard-test/issues/20): Add the `:rubygems` options for projects that don't use Bundler. ([@rymai][])

## 0.4.3 - December 19, 2011 - ([@rymai][])

### Bug fix:

- [#21](https://github.com/guard/guard-test/issues/21): Guard::Test::Notifier.notify - did not use :failed image if test results included errors but NO failures. ([@carlost][])

## 0.4.2 - November 19, 2011 - ([@rymai][])

### Bug fix:

- [#19](https://github.com/guard/guard-test/issues/19): Fixed "superclass mismatch for class Test (TypeError)" thanks to [@gertas][].

## 0.4.1 - November 3, 2011 - ([@rymai][])

### Bugs fixes:

- [#18](https://github.com/guard/guard-test/issues/18): Fixed a conflict with test_benchmark that was preventing guard-test from running.
- [#11](https://github.com/guard/guard-test/issues/11): Fixed a "No such file to load -- guard/notifier" when running guard without bundler.

## 0.4.0 - September 29, 2011 - ([@rymai][])

### Regression:

- Removed support of [turn](https://github.com/guard/guard-spork) gem since "Turn is no longer compatible with TestUnit 2.0+. TestUnit and MiniTest are deverging and after some consideration it was decided that Turn's goal is to support Ruby's native test framework, whatever it may be." quoted from Turn's [release.txt](https://github.com/TwP/turn/blob/master/Release.txt).

### New feature:

- New `:drb` option enabling the use of [`spork-testunit`](https://github.com/timcharper/spork-testunit) gem (be sure to use [guard-spork](https://github.com/guard/guard-spork) as well).

## 0.3.1 - September 11, 2011

### New feature:

- [#13](https://github.com/guard/guard-test/issues/13): New `test_paths` option to look for test files under other paths than `test`. ([@Ask11][])

### Improvement:

- [#15](https://github.com/guard/guard-test/issues/15): Simplify some checks. ([@dasch][])

## 0.3.0 - June 14, 2011

### Improvement:

- Internal cleaning. ([@rymai][])

## 0.3.0.rc5 - June 9, 2011

### Bugs fixes:

- Fixed bug that was preventing tests from running. ([@rymai][])
- Fixed the `fastfail` runner that was displaying a green dot even for a failing test. ([@rymai][])
- Removed the `:notification` option. Use the new Guard method instead. ([@rymai][])

### New feature:

- Turn seems to work fine now... ([@rymai][])

### Improvement:

- Consider 'test_*.rb' as test files as well. ([@uk-ar][])

## 0.3.0.rc4 - June 3, 2011 - ([@rymai][])

### Bugs fix:

- Add a require that was making the guard be fired by Guard! :'(

## 0.3.0.rc3 - June 3, 2011 - ([@rymai][])

### Bugs fix:

- Actually make the tests run.

### Regression:

- Turn doesn't want to run, so remove sentences that say that it is supported for now. Note: The code is still here, only the command line doesn't seem to output anything...

## 0.3.0.rc2 - June 2, 2011 - ([@rymai][])

### New features:

- New `:cli` option (nil by default) to pass arbitrary CLI arguments to the Ruby/Turn command that runs the tests.
- New `:notification` option (true by default) to disable notification (Growl/Inotify).
- New `:all_on_start` option (true by default) to not run all the tests at startup.
- New `:all_after_pass` option (true by default) to run all tests after changed tests pass.
- New `:keep_failed` option (true by default) to keep failed tests until them pass.

### Improvements:

- Added compatibility with 1.8.6, 1.8.7, 1.9.2, REE, Rubinius and JRuby.
- Internal changes inspired by [guard-minitest](https://github.com/guard/guard-minitest).

## 0.1.6 - January 24, 2011

### Bugs fix:

- [#2](https://github.com/guard/guard-test/issues/2): Fixed a bug introduced in 0.1.5 where test/ was not added to the $LOAD_PATH. (reported by [@jgrau][], fixed by [@rymai][])

## 0.1.5 - January 21, 2011 - ([@rymai][])

- Updated gem dependencies

## 0.1.4 - December 15, 2010

### Bugs fix:

- [#1](https://github.com/guard/guard-test/pull/1): Include errors count to determine the "flag" to display in notification. ([@gregorymostizky][])

[@Ask11]: https://github.com/Ask11
[@carlost]: https://github.com/carlost
[@coderjoe]: https://github.com/coderjoe
[@dasch]: https://github.com/dasch
[@gertas]: https://github.com/gertas
[@gregorymostizky]: https://github.com/gregorymostizky
[@jgrau]: https://github.com/jgrau
[@rymai]: https://github.com/rymai
[@uk-ar]: https://github.com/uk-ar
