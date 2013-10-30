# Guard::Test

[![Gem Version](https://badge.fury.io/rb/guard-test.png)](http://badge.fury.io/rb/guard-test) [![Build Status](https://travis-ci.org/guard/guard-test.png?branch=master)](https://travis-ci.org/guard/guard-test) [![Dependency Status](https://gemnasium.com/guard/guard-test.png)](https://gemnasium.com/guard/guard-test) [![Code Climate](https://codeclimate.com/github/guard/guard-test.png)](https://codeclimate.com/github/guard/guard-test) [![Coverage Status](https://coveralls.io/repos/guard/guard-test/badge.png?branch=master)](https://coveralls.io/r/guard/guard-test)

Guard::Test allows to automatically & intelligently launch tests when files are modified or created.

* Compatible with Test::Unit 2.
* Tested against Ruby 1.9.3, 2.0.0, Rubinius & JRuby (1.9 mode only).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Add the gem to your Gemfile (inside the `:development` or `:tool` group):

``` ruby
group :development do
  gem 'guard-test'
end
```

Add guard definition to your Guardfile by running this command:

``` bash
$ guard init test
```

## Ruby on Rails

Ruby on Rails lazy loads gems as needed in its test suite.
As a result Guard::Test may not be able to run all tests until the gem dependencies are resolved.

To solve the issue either add the missing dependencies or remove the tests.

Example:

```
Specify ruby-prof as application's dependency in Gemfile to run benchmarks.
```

Rails automatically generates a performance test stub in the `test/performance` directory which can trigger this error.
Either add `ruby-prof` to your `Gemfile` (inside the `test` group):

``` ruby
group :test do
   gem 'ruby-prof'
end
```

Or remove the test if it isn't necessary.

## Usage

Please read the [Guard usage doc](https://github.com/guard/guard#readme).

By default, Guard::Test watch for files matching `test_*.rb` or `*_test{s,}.rb` in the `test` directory (this directory can be changed with the `test_paths` option, see below).

## Guardfile

See the [template Guardfile](https://github.com/guard/guard-test/blob/master/lib/guard/test/templates/Guardfile) for some examples.

Please read the [Guard documentation](https://github.com/guard/guard#readme) for more info about the Guardfile DSL.

## Options

**Deprecation notice:** The `:runner` option is deprecated. If you had set it to "fastfail", it is now the default in test-unit 2, but if you want the opposite, you can pass the `cli: '--no-show-detail-immediately'` option instead.

### Available options

``` ruby
bundler: false          # Whether or not to use `bundle exec` to run tests, default: true (if a you have a Gemfile in the current directory)
rubygems: true          # Whether or not to require rubygems (if bundler isn't used) when running the tests, default: false
rvm: ['1.9.3', 'jruby'] # Directly run your specs against multiple Rubies, default: nil
spring: true            # Run your tests with [`spring`](https://github.com/jonleighton/spring), default: false
zeus: true              # Run your tests with [`zeus`](https://github.com/burke/zeus), default: false
drb: true               # Run your tests with [`spork-testunit`](https://github.com/timcharper/spork-testunit), default: false
include: ['foo', 'bar'] # Pass arbitrary include paths to the command that runs the tests, default: ['test']
cli: 'color'            # Pass arbitrary CLI arguments to the command that runs the tests, default: nil
all_on_start: false     # Run all tests on Guard startup, default: true.
all_after_pass: false   # Run all tests after the current run tests pass, default: true
keep_failed: false      # Re-run failing tests until they pass, default: true
test_paths: ['spec']    # Array of paths that where are located the test files, default: ['test']
```

#### `spring` option

**Important:** The `spring testunit` command of official version 0.0.8 of spring is running only file specified as first argument, other are ignored. Fortunately this issue has been fixed recently in spring master and all test files given in arguments are invoked, see [#102](https://github.com/jonleighton/spring/pull/102). However that has not been packaged yet, therefore while waiting for spring 0.0.9 release we recommend to use (in your Gemfile):

```ruby
gem 'spring', github: 'jonleighton/spring'
```

#### `zeus` option

When true, the `include` option is disregarded, as it does not work with `zeus`' test runner.

The zeus server process (`zeus start`) must already be running in another terminal (you can use [guard-zeus](http://rubygems.org/gems/guard-zeus) for that).

#### `drb` option

When true, notifications are disabled. This might be fixed in future releases.

## Development

* Documentation hosted at [RubyDoc](http://rubydoc.info/gems/guard-test/frames).
* Source hosted at [GitHub](https://github.com/guard/guard-test).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass on [Travis CI](https://travis-ci.org/guard/guard-test).
* Update the [Yard](http://yardoc.org/) documentation.
* Update the [README](https://github.com/guard/guard-test/blob/master/README.md).
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Author

[Rémy Coutable](https://github.com/rymai)

## Contributors

[https://github.com/guard/guard-test/graphs/contributors](https://github.com/guard/guard-test/graphs/contributors)
