# CollectionSpace Client

CollectionSpace API client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collectionspace-client'
```

And then execute `bundle install`, or install it yourself as: `gem install collectionspace-client`.

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

## Publishing

Bump version in `lib/collectionspace/client/version.rb` then:

```bash
VERSION=0.3.0
git add .
git commit -m "Bump version: v${VERSION}"
git push origin master
git tag v$VERSION
git push --tags
gem build collectionspace-client
gem push collectionspace-client-$VERSION.gem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/collectionspace/collectionspace-client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
