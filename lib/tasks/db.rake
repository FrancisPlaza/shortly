namespace :db do
  
  desc 'Wipes all data and tables from the database'
  task :wipe do
    unless Shortly.env == 'development' || Shortly.env == 'test'
      raise 'db:wipe can only be run in development'
    end
    Shortly::DB.tables.each do |table|
      Shortly::DB.drop_table table
    end
  end

  desc 'Adds all necessary tables and columns to run Shortly'
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(Shortly::DB, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(Shortly::DB, "db/migrations")
    end
  end
end