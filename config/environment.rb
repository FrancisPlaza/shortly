# Create log folder if does not exist
dir = File.expand_path('../../log', __FILE__)
FileUtils.mkdir_p(dir) unless File.directory?(dir)

ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH.unshift(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'shortly'