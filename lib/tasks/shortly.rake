desc 'Boot a console with Shortly environment loaded'
task :console do
  exec 'pry -I config -r environment -r shortly'
end

desc 'Start the Shortly API service on port 3000'
task :server do
  exec 'rackup -s puma -p 3000'
end