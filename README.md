CollectionSpace Client
===

CollectionSpace API client.

Installation
---

Add this line to your application's Gemfile:

```ruby
gem 'collectionspace-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install collectionspace-client

Usage
---

Basic usage:

```ruby
require 'collectionspace/client'

config = CollectionSpace::Configuration.new({
  base_uri: "https://cspace.muesum.org/cspace-services",
  username: "admin@cspace.muesum.org",
  password: "Administrator",
})

client = CollectionSpace::Client.new(config)

result = client.post_blob_uri "http://cspace.muesum.org/assets/mueseum.png"

raise "=(" if result.status_code != 201

search_args = {
  path: "blobs",
  type: "blobs_common",
  field: "name",
  expression: "ILIKE '%museum.png%'",
}

query = CollectionSpace::Search.new.from_hash search_args

result = client.search(query)

if result.status_code == 200
  ap result.parsed['abstract_common_list']
end
```

See the sample scripts within the `examples` directory for more.

Development
---

To run the examples:

```bash
bundle exec ruby examples/demo.rb
```

Any script placed in the examples directory with a `my_` prefix are ignored by git. Follow the convention used by the existing scripts to bootstrap and experiment away.

To run the tests:

```bash
bundle exec rake
```

Publishing
---

Bump version in `lib/collectionspace/client/version.rb` then:

```bash
VERSION=0.1.3
gem build collectionspace-client
gem push collectionspace-client-$VERSION.gem
git tag v$VERSION
git push --tags
```

Contributing
---

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/collectionspace-client.

License
---

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
