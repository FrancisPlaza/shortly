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

    post '/shorten' do
      req = MultiJson.load(request.body.read, symbolize_keys: true)
      short_url = Shortly::Shortener.shorten(req[:url], req[:shortcode])
      status 201
      MultiJson.dump({shortcode: short_url.shortcode})
    end

  end
end