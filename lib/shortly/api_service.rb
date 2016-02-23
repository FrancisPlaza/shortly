require 'sinatra/base'
module Shortly
  class APIService < Sinatra::Base
    use Shortly::WebLogger, Shortly.loggers[:web]

    configure do
      enable :logging, :dump_errors
      enable :raise_errors
    end

    before do
      headers "Content-Type" => "application/json; charset=utf-8"
    end

    get '/' do
      MultiJson.dump({app: 'Shortly', status: 'ok', version: Shortly::VERSION})
    end

  end
end