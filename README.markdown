# Guard::Test ![travis-ci](http://travis-ci.org/guard/guard-test.png)

Test::Unit guard allows to automatically & intelligently launch tests when files are modified or created.

## Compatibility

- Compatible with Test::Unit ~> 2.2.
- Tested on Ruby 1.8.7, REE and 1.9.2.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

If you're using Bundler, add it to your `Gemfile` (inside the `test` group):
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
  watch(%r{lib/(.+)\.rb})      { |m| "test/#{m[1]}_test.rb" }
  watch(%r{test/.+_test\.rb})
  watch('test/test_helper.rb') { "test" }
end
```

### Ruby On Rails project
```ruby
guard 'test' do
  watch(%r{app/models/(.+)\.rb})                     { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{app/controllers/(.+)\.rb})                { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{app/views/.+\.rb})                        { "test/integration" }
  watch(%r{lib/(.+)\.rb})                            { |m| "test/#{m[1]}_test.rb" }
  watch(%r{test/.+_test.rb})
  watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  watch('test/test_helper.rb')                       { "test" }
end
```

Please read [Guard doc](https://github.com/guard/guard#readme) for more info about Guardfile DSL.

## Options

Guard::Test allows you to choose between two different runners (Guard::Test's runners are inherited from Test::Unit's console runner):

- `default`: Display tests results as they happen, with different chars (green `.` for pass, red `F` for fail, purple `E` for error) 
             and print failures/errors messages & backtraces when all the tests are finished. Obviously, this is the guard-test default.
- `fastfail`: Display tests results as they happen and print failures/errors messages & backtraces immediately.

Available options:
```ruby
:notify => false           # don't display Growl (or Libnotify) notification after the specs are done running, default: true
:runner => 'fastfail'      # default: 'default'
:bundler => false          # don't use "bundle exec" to run the test command, default: true if a you have a Gemfile
:rvm => ['1.8.7', '1.9.2'] # directly run your specs on multiple Rubies, default: nil
:verbose => true           # default: false
```

### Note about the `:notify` option

If you don't want to use Growl or Libnotify with any of your guards, you can set a `GUARD_NOTIFY` environment variable to `false`.
You can do it by adding the following statement in you `.bashrc`/`.bash_profile`/`.zshrc`:
```bash
export GUARD_NOTIFY=false
```

Set the desired options as follow method:
```ruby
guard 'test', :runner => 'fastfail', :bundler => false, :rvm => ['1.8.7', 'ree'] do
  ...
end
```

## Development

- Source hosted on GitHub: https://github.com/guard/guard-test
- Report issues/Questions/Feature requests on GitHub Issues: https://github.com/guard/guard-test/issues

Pull requests are very welcome!
Make sure your patches are well tested.
Please create a topic branch for every separate change you make.

## Versioning

Guard::Test follows [Semantic Versioning](http://semver.org), both SemVer and SemVerTag.

## Author

[Rémy Coutable](https://github.com/rymai)

## Contributors

https://github.com/guard/guard-test/contributors

## Kudos

Many thanks to [Thibaud Guillaume-Gentil](https://github.com/thibaudgg) for creating the excellent Guard gem.
