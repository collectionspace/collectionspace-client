lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "collectionspace/client/version"

Gem::Specification.new do |spec|
  spec.name = "collectionspace-client"
  spec.version = CollectionSpace::Client::VERSION
  spec.authors = ["Mark Cooper"]
  spec.email = ["mark.cooper@lyrasis.org"]

  spec.summary = "CollectionSpace API client."
  spec.description = "Client for interacting with CollectionSpace Services API"
  spec.homepage = "https://github.com/lyrasis/collectionspace-client.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.4"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "json"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "webmock"
end
