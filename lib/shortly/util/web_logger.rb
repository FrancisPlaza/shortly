module Shortly
  class WebLogger
    def initialize(app, logger)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = Time.now
      status, header, body = @app.call(env)
      log(env, status, began_at)
      [status, header, body]
    end

    private

    def log(env, status, began_at)
      return if env['REQUEST_METHOD'] == 'OPTIONS'
      @logger.info "#{env['REQUEST_METHOD']} #{env['PATH_INFO']}" +
        (env['QUERY_STRING'].blank? ? '' : '?') +
        "#{env['QUERY_STRING']} for #{env['REMOTE_ADDR']}"
      @logger.info env['rack.request.form_hash'].inspect unless env['rack.request.form_hash'].blank?
      @logger.info "Response #{status} - #{((Time.now - began_at)*1000).to_i}ms\n"
    end

  end
end