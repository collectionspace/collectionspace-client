# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"
require "csv"

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: "https://core.dev.collectionspace.org/cspace-services",
    username: "admin@core.collectionspace.org",
    password: "Administrator"
  )
)
client.config.throttle = 1

path = File.expand_path("~/your/path/here.csv")

CSV.foreach(path, headers: true) do |row|
  client.reset_media_blob(
    id: row["identificationnumber"],
    url: row["mediafileuri"],
    verbose: true,
    # client files are on same server as CS instance, and ingestable
    #   file paths do not all parse as URIs safely
    ensure_safe_url: false,
    # This example script used to fix media where the blobs had already
    #   been deleted, but the blobcsid value was not removed from the
    #   media record. Attempts to delete the media failed, so this option
    #   was used to add new blobs without attempting to delete the already
    #   deleted old blobs (and erroring out)
    delete_existing_blob: false
  )
  sleep 1.5
end
