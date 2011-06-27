## 0.3.0 - June 14, 2011

### Improvements:

- Internal cleaning. ([@rymai][])

## 0.3.0.rc5 - June 9, 2011

### Bugs fixes:

- Fixed bug that was preventing tests from running. ([@rymai][])
- Fixed the `fastfail` runner that was displaying a green dot even for a failing test. ([@rymai][])
- Removed the `:notification` option. Use the new Guard method instead. ([@rymai][])

### New features:

- Turn seems to work fine now... ([@rymai][])

### Improvement:

- Consider 'test_*.rb' as test files as well. ([@uk-ar][])

## 0.3.0.rc4 - June 3, 2011 - ([@rymai][])

### Bugs fixes:

- Add a require that was making the guard be fired by Guard! :'(

## 0.3.0.rc3 - June 3, 2011 - ([@rymai][])

### Bugs fixes:

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

### Improvement:

- Added compatibility with 1.8.6, 1.8.7, 1.9.2, REE, Rubinius and JRuby.
- Internal changes inspired by [guard-minitest](https://github.com/guard/guard-minitest).

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
[@uk-ar]: https://github.com/uk-ar
