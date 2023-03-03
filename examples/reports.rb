# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"

STANDARD_TENANTS = [
  :anthro,
  :bonsai,
  :botgarden,
  :core,
  :fcart,
  :herbarium,
  :lhmc,
  :materials,
  :publicart
]

# https://github.com/collectionspace/Tools/blob/master/scripts/install_report_records.sh
# https://github.com/collectionspace/Tools/blob/master/scripts/create-report-records.sh

STANDARD_REPORTS = CollectionSpace::Report.all

STANDARD_TENANTS.each do |tenant|
  client = CollectionSpace::Client.new(
    CollectionSpace::Configuration.new(
      base_uri: "https://#{tenant}.dev.collectionspace.org/cspace-services",
      username: "admin@#{tenant}.collectionspace.org",
      password: "Administrator"
    )
  )
  base = client.config.base_uri
    .delete_suffix("/cspace-services")
    .delete_prefix("https://")

  STANDARD_REPORTS.each do |report|
    response = client.add_report(report)
    if response.result.success?
      puts "Added #{report[:name]} to #{base}"
    else
      puts "FAILED TO ADD #{report[:name]} to #{base}"
      puts response.inspect
    end
  end
end
