$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'
require 'date'

# MONKEY PATCHING FOR RAILS LIKE 3.days.ago
class Fixnum
  SECONDS_IN_DAY = 24 * 60 * 60

  def days
    self * SECONDS_IN_DAY
  end

  def ago
    Time.now - self
  end
end

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new
client.config.throttle = 1

# GET ALL CATALOGING RECORDS AND DUMP THE XML IF UPDATED SINCE 3 DAYS AGO
client.all('collectionobjects').each do |item|
  updated = Date.parse item["updatedAt"]
  if updated > Date.parse(14.days.ago.to_s)
    collectionobject = client.get item["uri"]
    # TO EXPORT WRITE THE BODY TO FILE, HERE WE JUST PRINT IT
    ap collectionobject.body # OR .xml.to_s
  end
end
