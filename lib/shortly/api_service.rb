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

    helpers do
      def wrap_in_rescue
        begin
          yield
        rescue Shortly::ShortlyError => e
          error = {error_code: e.http_status || 406, message: e.message}
          error[:backtrace] = e.backtrace unless Shortly.production?
          halt(e.http_status || 406, MultiJson.dump(error))
        rescue Exception => e
          error = {error_code: 406, message: e.message}
          error[:backtrace] = e.backtrace unless Shortly.production?
          halt(406, MultiJson.dump(error))
        end
      end
    end

    get '/' do
      MultiJson.dump({app: 'Shortly', status: 'ok', version: Shortly::VERSION})
    end

    post '/shorten' do
      wrap_in_rescue do
        req = MultiJson.load(request.body.read, symbolize_keys: true)
        raise Shortly::ShortlyError.new(
          "url is not present.", 400)if req[:url].blank?
        short_url = Shortly::Shortener.shorten(req[:url], req[:shortcode])
        status 201
        MultiJson.dump({shortcode: short_url.shortcode})
      end
    end

    get '/:shortcode' do
      wrap_in_rescue do
        short_url = Shortly::Shortener.redirect(params['shortcode'])
        redirect short_url.url, 302
      end
    end

    get '/:shortcode/stats' do
      wrap_in_rescue do
        response = Shortly::Shortener.stats(params['shortcode'])
        MultiJson.dump(response)
      end
    end
  end
end