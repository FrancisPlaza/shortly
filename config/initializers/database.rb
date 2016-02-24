def pg_connection_string
  return ENV['DATABASE_URL'] if Shortly.production?
  settings = YAML::load(File.read('config/database.yml'))[Shortly.env]
  settings['host'] ||= 'localhost'
  settings['port'] ||= '5432'

  "#{settings['adapter']}://#{settings['username']}:#{settings['password']}@#{settings['host']}:#{settings['port']}/#{settings['database']}"
end
Shortly::DB = Sequel.connect(pg_connection_string)
Shortly::DB.loggers << Shortly.loggers[:sql]
Sequel.default_timezone = :utc

Shortly::DB.sql_log_level = :debug
Shortly::DB.log_warn_duration = 0.1