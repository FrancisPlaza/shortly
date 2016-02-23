require 'sequel'
require 'yaml'
require 'multi_json'
require 'logger'

MultiJson.use(:oj) # Use Oj as adapter

require 'shortly/version'
require 'shortly/util'

# Global initializers
Dir["#{Shortly.root}/config/initializers/*.rb"].sort.each do |initializer_file|
  require(initializer_file)
end

require 'shortly/api_service'