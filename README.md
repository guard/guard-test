# Guard::Test [![Build Status](http://travis-ci.org/guard/guard-test.png)](http://travis-ci.org/guard/guard-test)

Test::Unit guard allows to automatically & intelligently launch tests when files are modified or created.

If you have any questions about Guard or Guard::Test, please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Features

- Compatible with Test::Unit >= 2.2.
- Tested on Ruby 1.8.7, 1.9.2, REE, Rubinius and JRuby.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

If you're using Bundler, add it to your `Gemfile` (inside the `development` group):

```ruby
gem 'guard-test'
```

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

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme).

## Guardfile

Guard::Test can be adapted to any kind of projects.

### Standard Ruby project

```ruby
guard 'test' do
  watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb')  { "test" }
end
```

### Ruby On Rails project

```ruby
guard 'test' do
  watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
  watch(%r{^lib/(.+)\.rb$})                          { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test.rb$})
  watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  watch('test/test_helper.rb')                       { "test" }
end
```

Please read the [Guard documentation](https://github.com/guard/guard#readme) for more info about the Guardfile DSL.

## Options

Guard::Test allows you to choose between two different runners (Guard::Test's runners are inherited from Test::Unit's console runner):

- `default`: Display tests results as they happen, with different chars (green `.` for pass, red `F` for fail, purple `E` for error) 
             and print failures/errors messages & backtraces when all the tests are finished. Obviously, this is the guard-test default.
- `fastfail`: Display tests results as they happen and print failures/errors messages & backtraces immediately.

By default, guard-test will only look for test files within test/ in your project root. You can add any paths using :test_paths option:

```ruby
guard 'test', :test_paths => ['test/', 'vendor/plugins/recaptcha/test/', 'any/path/test/'] do
  # ...
end
```

Available options:

```ruby
:rvm            => ['1.8.7', '1.9.2'] # directly run your specs on multiple Rubies, default: nil
:bundler        => false              # don't use "bundle exec" to run the test command, default: true if a you have a Gemfile
:runner         => 'fastfail'         # default: 'default'
:cli            => "-v"               # pass arbitrary CLI arguments to the Ruby command that runs the tests, default: nil
:all_on_start   => false              # don't run all the tests at startup, default: true
:all_after_pass => false              # don't run all tests after changed tests pass, default: true
:keep_failed    => false              # keep failed tests until them pass, default: true
:test_paths     => ['test/']          # specify an array of paths that contain test files
```

## Development

- Source hosted on GitHub: https://github.com/guard/guard-test
- Report issues and feature requests to GitHub Issues: https://github.com/guard/guard-test/issues

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change you make. Please do not change the version in your pull-request.

For questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Author

[Rémy Coutable](https://github.com/rymai)

## Contributors

https://github.com/guard/guard-test/contributors

## Kudos

Many thanks to [Thibaud Guillaume-Gentil](https://github.com/thibaudgg) for creating the excellent [Guard](https://github.com/guard/guard) gem.
