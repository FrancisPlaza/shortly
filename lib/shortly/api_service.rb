require 'sinatra/base'
module Shortly
  class APIService < Sinatra::Base

    before do
      headers "Content-Type" => "application/json; charset=utf-8"
    end

    get '/' do
      MultiJson.dump({app: 'Shortly', status: 'ok', version: Shortly::VERSION})
    end

  end
end