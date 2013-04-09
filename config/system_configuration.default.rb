# -*- encoding : utf-8 -*-
# place per-project configurations here

# EMAIL SETTINGS #############################
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'gmail.com',
  :user_name => 'my_account',
  :password => 'your_password',
  :enable_starttls_auto => true,
  :authentication => :login
}

# CACHE SETTINGS ##############################
config.cache_store = :mem_cache_store, 'localhost'
# - Use Libmemcached gem 
# config.cache_store = :libmemcached_store, "localhost:11211", {
#  :use_udp => true,
#  :binary_protocol => true,
#  :buffer_requests => true,
#  :retry_timeout => 3,
#  :server_failure_limit => 10,
#  :no_block => true,
#  :show_backtraces => true,
# }
# config.action_controller.session_store = :libmemcached_store
#
# - Use Ehcache (for jruby)
# require 'active_support/ehcache_store'
# config.cache_store = :ehcache_store
config.action_controller.session_store = :mem_cache_store

begin
config.middleware.use ::Rack::Cache, {
#  :metastore => 'memcached://localhost:11211',
#  :entitystore => 'memcached://localhost:11211'
#  :metastore => 'file:/tmp/cache/rack/meta',
#  :entitystore => 'file:/tmp/cache/rack/body' 
}
rescue 
puts 'cannot load rack-cache'
end
