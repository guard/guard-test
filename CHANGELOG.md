### New features:

- Auto-detection of the `turn` gem.
- New `:cli` option (nil by default) to pass arbitrary CLI arguments to the Ruby/Turn command that runs the tests. ([@rymai][])
- New `:notification` option (true by default) to disable notification (Growl/Inotify). ([@rymai][])
- New `:all_on_start` option (true by default) to not run all the tests at startup. ([@rymai][])
- New `:all_after_pass` option (true by default) to run all tests after changed tests pass. ([@rymai][])
- New `:keep_failed` option (true by default) to keep failed tests until them pass. ([@rymai][])

### Improvement:

- Added compatibility with 1.8.6, 1.8.7, 1.9.2, REE, Rubinius and JRuby.
- Internal changes inspired by [guard-minitest](https://github.com/guard/guard-minitest) ([@rymai][])

## 0.1.6 - January 24, 2011

### Bugs fixes:

- Issue [#2](https://github.com/guard/guard-test/issues/2): Fixed a bug introduced in 0.1.5 where test/ was not added to the $LOAD_PATH. (reported by [@jgrau][], fixed by [@rymai][])

## 0.1.5 - January 21, 2011

### Changes:

- Updated gem dependencies

## 0.1.4 - December 15, 2010

### Bugs fixes:

- Pull request [#1](https://github.com/guard/guard-test/pull/1): Include errors count to determine the "flag" to display in notification. ([@gregorymostizky][])

[@gregorymostizky]: https://github.com/gregorymostizky
[@jgrau]: https://github.com/jgrau
[@rymai]: https://github.com/rymai
