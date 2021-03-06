require 'active_support'
require 'active_support/core_ext'
require 'sequel'
require 'yaml'
require 'multi_json'
require 'logger'

MultiJson.use(:oj) # Use Oj as adapter

require 'shortly/version'
require 'shortly/util'
require 'shortly/shortener'

# Global initializers
Dir["#{Shortly.root}/config/initializers/*.rb"].sort.each do |initializer_file|
  require(initializer_file)
end

require 'shortly/errors/shortly_error'
require 'shortly/models/short_url'
require 'shortly/api_service'