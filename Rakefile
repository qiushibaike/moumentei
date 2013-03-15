# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/task'

require 'tasks/rails'
begin
  gem "thinking-sphinx",'~> 1.3.11'
  require 'thinking_sphinx/tasks'
rescue LoadError
  puts 'Cannot load thinking_sphinx tasks'
end
begin
  gem 'delayed_job', '~>2.0.4'
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `rake gems:install` to install delayed_job"
end