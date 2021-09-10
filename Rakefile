# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'base64'
require 'collectionspace/client'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :cli do
  desc "Update a user's password: requires an Admin level account to perform the update"
  task :update_password, [:endpoint, :admin, :password, :user, :new_password] do |_t, args|
    endpoint     = args[:endpoint]
    admin        = args[:admin]
    password     = args[:password]
    user         = args[:user]
    new_password = args[:new_password]

    client = CollectionSpace::Client.new(
      CollectionSpace::Configuration.new(
        base_uri: endpoint,
        username: admin,
        password: password
      )
    )

    payload = <<~XML
      <ns2:accounts_common xmlns:ns2="http://collectionspace.org/services/account">
          <userId>#{user}</userId>
          <password>#{Base64.encode64(new_password).chomp}</password>
      </ns2:accounts_common>
    XML

    client.all('accounts').each do |account|
      if account['email'] == user
        puts client.put(account['uri'], payload).parsed
        break
      end
    end
  end
end
