# CollectionSpace Client

CollectionSpace API client.

## Installation

Add this line to your application's Gemfile (replace `$VERSION` with an available tag):

```ruby
gem 'collectionspace-client', tag: $VERSION, git: 'https://github.com/collectionspace/collectionspace-client.git'
```

And then execute `bundle install`.

## Usage

See the sample scripts within the [examples](examples/) directory.

## Development

To run the examples:

```bash
bundle exec ruby examples/demo.rb
```

Any script placed in the examples directory with a `my_` prefix are ignored by git. Follow the convention used by the existing scripts to bootstrap and experiment away.

To run the tests:

```bash
bundle exec rake
```

## Releasing

```bash
gem install gem-release
# https://github.com/svenfuchs/gem-release#gem-bump
gem bump --version $VERSION
# i.e.
gem bump --version minor --pretend # dryrun
gem bump --version minor # do it for real
bundle # update gem version in Gemfile.lock
# PR and merge will publish new version
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/collectionspace/collectionspace-client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
