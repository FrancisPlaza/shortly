require 'spec_helper'
require 'rack/test'

RSpec.describe APIService do
  include Rack::Test::Methods

  def app
    @app ||= APIService
  end

  it "responds 200 to /" do
    get '/'
    expect(last_response.status).to eq 200
  end

  it "responds 404 to garbage route" do
    get '/francis_rocks?foo=bar'
    expect(last_response.status).to eq 404
  end

  it "responds 201 when new shortcode is created" do
    query = { url: "https://www.google.com" }
    post '/shorten', query.to_json
    expect(last_response.status).to eq 201
  end

  it "responds 422 when shortcode is invalid" do
    query = { url: "https://www.google.com",
      shortcode: "123" }
    post '/shorten', query.to_json
    expect(last_response.status).to eq 422
  end

  it "responds 422 when url is invalid" do
    query = { url: "bad_url" }
    post '/shorten', query.to_json
    expect(last_response.status).to eq 422
  end

  it "responds 400 when shortcode is not present" do
    query = { shortcode: "123" }
    post '/shorten', query.to_json
    expect(last_response.status).to eq 400
  end

  it "responds 409 when shortcode is in use" do
    Shortly::ShortUrl.create({ shortcode: "abcdef",
      url: "https://example.com"})
    query = { url: "https://www.google.com",
      shortcode: "abcdef" }
    post '/shorten', query.to_json
    expect(last_response.status).to eq 409
  end

  it "responds 302 to GET /:shortcode" do
    Shortly::ShortUrl.create({ shortcode: "google",
      url: "https://google.com"})
    get '/google'
    expect(last_response.status).to eq 302
  end

  it "responds 404 to missing shortcode" do
    get '/Jh9Us4'
    expect(last_response.status).to eq 404
  end

  it "responds 404 when shortcode is missing for stats" do
    get '/h28Bns/stats'
    expect(last_response.status).to eq 404
  end

  it "responds 200 to GET /:shortcode/stats" do
    Shortly::ShortUrl.create({ shortcode: "exmpl",
      url: "https://google.com"})
    get '/exmpl/stats'
    expect(last_response.status).to eq 200
  end
end