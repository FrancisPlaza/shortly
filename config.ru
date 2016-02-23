require File.expand_path('../config/environment', __FILE__)

# Start the service
run Rack::URLMap.new(
  '/'         => Shortly::APIService,
  '/ha-check' => lambda do |env|
    [ 200, {"Content-Type" => 'application/json'}, ['{"status": "ok"}'] ]
  end
)