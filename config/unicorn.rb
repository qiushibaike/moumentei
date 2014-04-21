# coding: utf-8
# Set your full path to application.
app_path = File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__))))

# Set unicorn options
worker_processes 3
preload_app true
timeout 30
listen "#{app_path}/tmp/sockets/unicorn.sock", :backlog => 2048
#listen "127.0.0.1:9000"

# Spawn unicorn master worker for user apps (group: apps)
#user 'shiningray', 'shiningray'

# Fill path to your app
working_directory app_path

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] ||= "#{app_path}/Gemfile"
end

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
