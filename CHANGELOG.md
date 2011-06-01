### New features:

- New `:all_on_start` option (true by default) to not run all the tests at startup. ([@rymai](https://github.com/rymai))
- New `:all_after_pass` option (true by default) to run all tests after changed tests pass. ([@rymai](https://github.com/rymai))
- New `:keep_failed` option (true by default) to keep failed tests until them pass. ([@rymai](https://github.com/rymai))
- New `:notify` option (true by default) to disable notification (Growl/Inotify). ([@rymai](https://github.com/rymai))
- New `:use_turn` option (false by default) to use `turn` (from the ([turn gem](http://rubygems.org/gems/turn))) instead of `ruby`. ([@rymai](https://github.com/rymai))

### Changes:

- Internal changes inspired by [guard-minitest](https://github.com/guard/guard-minitest) ([@rymai](https://github.com/rymai))

## 0.1.6 - January 24, 2011

### Bugs fixes:

- Issue [#2](https://github.com/guard/guard-test/issues/2): Fixed a bug introduced in 0.1.5 where test/ was not added to the $LOAD_PATH. (reported by [@jgrau](https://github.com/jgrau), fixed by [@rymai](https://github.com/rymai))

## 0.1.5 - January 21, 2011

### Changes:

- Updated gem dependencies

## 0.1.4 - December 15, 2010

### Bugs fixes:

- Pull request [#1](https://github.com/guard/guard-test/pull/1): Include errors count to determine the "flag" to display in notification. ([@gregorymostizky](https://github.com/gregorymostizky))
