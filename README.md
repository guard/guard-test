# Guard::Test [![Build Status](https://secure.travis-ci.org/guard/guard-test.png?branch=master)](http://travis-ci.org/guard/guard-test)

Test::Unit guard allows to automatically & intelligently launch tests when files are modified or created.

If you have any questions about Guard or Guard::Test, please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Features

- Compatible with test-unit 2.
- Tested on Ruby 1.8.7, 1.9.2, REE, Rubinius and JRuby.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

If you're using Bundler, add it to your `Gemfile`:

```ruby
group :tools do
  gem 'guard-test'
end
```

Note for Rails users: you should add it inside a `:tools` group (or at least not the `:development` nor `:test` group) to avoid the loading of the gem on Rails boot.

and run:

```bash
$ bundle install
```

or manually install the gem:

```bash
$ gem install guard-test
```

Add Guard definition to your `Guardfile` by running this command:

```bash
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

```ruby
group :test do
   gem 'ruby-prof'
end
```

Or remove the test if it isn't necessary.

## Usage

Please read the [Guard usage doc](https://github.com/guard/guard#readme).

## Guardfile

Guard::Test can be adapted to any kind of projects.

See the [template Guardfile](https://github.com/guard/guard-test/blob/master/lib/guard/test/templates/Guardfile) for some examples.

Please read the [Guard documentation](https://github.com/guard/guard#readme) for more info about the Guardfile DSL.

## Options

**Deprecation notice:** The `:runner` option is deprecated. If you had set it to "fastfail", it is now the default in test-unit 2, but if you want the opposite, you can pass the `:cli => '--no-show-detail-immediately'` option instead.

### Available options

* `bundler` (`Boolean`)          - Whether or not to use `bundle exec` to run tests. Default to `true` if a you have a Gemfile in the current directory.
* `rubygems` (`Boolean`)         - Whether or not to require rubygems (if bundler isn't used) when running the tests. Default to `false`.
* `rvm` (`Array<String>`)        - Directly run your specs against multiple Rubies. Default to `nil`.
* `drb` (`Boolean`)              - Run your tests with [`spork-testunit`](https://github.com/timcharper/spork-testunit). Default to `false`.
* `cli` (`String`)               - Pass arbitrary CLI arguments to the command that runs the tests. Default to `nil`.
* `all_on_start` (`Boolean`)     - Run all tests on Guard startup. Default to `true`.
* `all_after_pass` (`Boolean`)   - Run all tests after the current run tests pass. Default to `true`.
* `keep_failed` (`Boolean`)      - Re-run failing tests until they pass. Default to `true`.
* `test_paths` (`Array<String>`) - Array of paths that where are located the test files. Default to `['test']`.

#### `drb` option

When true, notifications are disabled. This might be fixed in future releases.

#### `test_paths` option

By default, guard-test will only look for test files within `test/` in your project root. You can add any paths using the `:test_paths` option:

```ruby
guard :test, :test_paths => ['test', 'vendor/plugins/recaptcha/test', 'any/path/test'] do
  # ...
end
```

## Development

- Source hosted on GitHub: https://github.com/guard/guard-test
- Report issues and feature requests to GitHub Issues: https://github.com/guard/guard-test/issues

Pull requests are very welcome! Please try to follow these simple "rules", though:

- Please create a topic branch for every separate change you make;
- Make sure your patches are well tested;
- Update the [README](https://github.com/guard/guard-test/blob/master/README.md) (if applicable);
- Update the [CHANGELOG](https://github.com/guard/guard-test/blob/master/CHANGELOG.md) and add yourself to the list of contributors (see at the bottom of the CHANGELOG for examples);
- Please do not change the version number.

For questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Author

[Rémy Coutable](https://github.com/rymai)

## Contributors

https://github.com/guard/guard-test/contributors

## Kudos

Many thanks to [Thibaud Guillaume-Gentil](https://github.com/thibaudgg) for creating the excellent [Guard](https://github.com/guard/guard) gem.
