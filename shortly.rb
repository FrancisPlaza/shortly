require 'sequel'
require 'yaml'
require 'multi_json'

MultiJson.use(:oj) # Use Oj as adapter

require 'shortly/version'
require 'shortly/util'

require 'shortly/api_service'