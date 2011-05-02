# Guard::Test

Test::Unit guard allows to automatically & intelligently launch tests when files are modified or created.

## Compatibility

- Compatible with Test::Unit ~> 2.2.
- Tested on Ruby 1.8.7, REE, 1.9.2, JRuby and Rubinius.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

```ruby
gem install guard-test
```

Add it to your Gemfile (inside test group):

```ruby
gem 'guard-test'
```

Add Guard definition to your Guardfile by running this command:

```ruby
guard init test
```

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme).

## Guardfile

Guard::Test can be adapted to many kind of projects.

### Standard Ruby project

```ruby
guard 'test' do
  watch(%r{lib/(.*)\.rb})      { |m| "test/#{m[1]}_test.rb" }
  watch(%r{test/.*_test\.rb})
  watch('test/test_helper.rb') { "test" }
end
```

### Ruby On Rails project

```ruby
guard 'test' do
  watch(%r{app/models/(.*)\.rb})                     { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{app/controllers/(.*)\.rb})                { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{app/views/.*\.rb})                        { "test/integration" }
  watch(%r{lib/(.*)\.rb})                            { |m| "test/#{m[1]}_test.rb" }
  watch(%r{test/.*_test.rb})
  watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  watch('test/test_helper.rb')                       { "test" }
end
```

Please read [Guard doc](https://github.com/guard/guard#readme) for more info about Guardfile DSL.

## Options

Guard::Test allows you to choose between two different runners (Guard::Test's runners are inherited from Test::Unit's console runner):
- `default`: Display tests results as they happen, with different chars ('.' for pass, 'F' for fail, 'E' for error) and print failures/errors messages & backtraces when all the tests are finished. Obviously, this is the guard-test default.
- `fastfail`: Display tests results as they happen and print failures/errors messages & backtraces immediately.

Available options:

```ruby
:runner => 'fastfail'      # default to 'default'
:bundler => false          # don't use "bundle exec"
:rvm => ['1.8.7', '1.9.2'] # directly run your specs on multiple ruby
```

Set the desired options as follow method:

```ruby
guard 'test', :runner => 'fastfail', :bundle => false, :rvm => ['1.8.7', 'ree'] do
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

## Kudos

Many thanks to [Thibaud Guillaume-Gentil](https://github.com/thibaudgg) for creating the excellent Guard gem.
