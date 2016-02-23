require(File.expand_path('../config/environment', __FILE__))

task :environment do
  # Nothing, just don't piss off tasks that depend on this one
end

# Load tasks from lib/tasks/*.rake
Dir["lib/tasks/*.rake"].each do |rakefile|
  load(File.expand_path(rakefile))
end