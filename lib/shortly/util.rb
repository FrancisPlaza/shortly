module Shortly
  ENVIRONMENTS = %w{test testbed development staging production}

  def self.root
    @@root ||= File.expand_path('../../..', __FILE__)
  end

  def self.env
    @@env ||= ENV['RACK_ENV']
  end

  # Rails-style Shortly.development? / Shortly.production? etc
  def self.method_missing(method, *args, &block)
    if method.to_s.end_with?('?')
      chopped = method.to_s[0..-2]
      if ENVIRONMENTS.include?(chopped)
        return(Shortly.env == chopped)
      end
    end

    # Punt
    super.method_missing(method, *args, &block)
  end

  def self.loggers
    @@loggers ||= {
      sql: Logger.new("#{Shortly.root}/log/sql.#{Shortly.env}.log", 'daily'),
      web: Logger.new("#{Shortly.root}/log/#{Shortly.env}.log", 'daily')
    }
  end
end

require 'shortly/util/web_logger'
require 'shortly/util/strrand'