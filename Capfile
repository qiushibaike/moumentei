default_run_options[:pty] = true
def environment  
  if exists?(:stage)
    stage
  elsif exists?(:rails_env)
    rails_env  
  elsif(ENV['RAILS_ENV'])
    ENV['RAILS_ENV']
  else
    "production"  
  end
end
load 'deploy' if respond_to?(:namespace) # cap2 differentiator
(Dir['vendor/plugins/*/recipes/*.rb']).each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks