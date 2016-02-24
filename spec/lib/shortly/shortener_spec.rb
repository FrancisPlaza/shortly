require 'spec_helper'
require 'rack/test'

RSpec.describe APIService do
  include Rack::Test::Methods

  def app
    @app ||= Shortener
  end

  it "should create new ShortUrl" do
    s = Shortly::Shortener.shorten("https://www.google.com")
    expect(s.url).to eq "https://www.google.com"
  end

  it "should raise error when url is invalid" do
    expect{ Shortly::Shortener.shorten("
      bad_url") }.to raise_error(Shortly::ShortlyError)
  end

  it "should raise error when shortcode is invalid" do
    expect{ Shortly::Shortener.shorten("https://www.google.com",
      "123") }.to raise_error(Shortly::ShortlyError)
  end

  it "should raise error when shortcode is in use" do
    Shortly::Shortener.shorten("https://www.google.com", "google")
    expect{ Shortly::Shortener.shorten("https://www.google.com",
      "google") }.to raise_error(Shortly::ShortlyError)
  end

  it "should return updated ShortUrl on redirect" do
    Shortly::Shortener.shorten("https://www.google.com", "exmpl")
    s = Shortly::Shortener.redirect("exmpl")
    expect(s.redirect_count).to eq 1
  end

  it "should raise error when shortcode is missing" do
    expect{ Shortly::Shortener.redirect("abcdef") }
      .to raise_error(Shortly::ShortlyError)
  end

  it "should not include lastSeenDate when redirect_count is 0" do
    Shortly::Shortener.shorten("https://www.google.com", "zxcvbn")
    expect(Shortly::Shortener.stats("zxcvbn")[:lastSeenDate])
      .to eq nil
  end

  it "should return updated redirect_count on stats" do
    stats = []
    Shortly::Shortener.shorten("https://www.google.com", "awesum")
    Shortly::Shortener.redirect("awesum")
    stats << Shortly::Shortener.stats("awesum")[:redirectCount]
    Shortly::Shortener.redirect("awesum")
    Shortly::Shortener.redirect("awesum")
    stats << Shortly::Shortener.stats("awesum")[:redirectCount]
    expect(stats).to eq [1, 3]
  end

  it "should update lastSeenDate when redirect_count is > 0" do
    Shortly::Shortener.shorten("https://www.google.com", "qwerty")
    Shortly::Shortener.redirect("qwerty")
    s = Shortly::Shortener.stats("qwerty")
    expect(s[:lastSeenDate]).to be > s[:startDate]
  end
end