#place per-project configurations here

config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'gmail.com',
  :user_name => 'gezhongnet',
  :password => 'RidicUle1+',
  :enable_starttls_auto => true,
  :authentication => :login
}

#config.gem 'memcached' # faster memcache client
#config.cache_store = :libmemcached_store, "localhost:11211", {
#  :use_udp => true,
#  :binary_protocol => true,
#  :buffer_requests => true,
#  :retry_timeout => 3,
#  :server_failure_limit => 10,
#  :no_block => true,
#  :show_backtraces => true,
#  }
# config.action_controller.session_store = :libmemcached_store

config.cache_store = :mem_cache_store, 'localhost'
config.action_controller.session_store = :mem_cache_store

if defined?(::ExceptionNotification)
  ExceptionNotification::Notifier.exception_recipients = %w(tsowly@qq.com)
  ExceptionNotification::Notifier.sender_address = %("Youwenti" <mail@bling0.com>)
  ExceptionNotification::Notifier.email_prefix = '[Youwenti]'
end

#config.middleware.use ::Rack::Cache,
#  :metastore => 'memcached://localhost:11211',
#  :entitystore => 'memcached://localhost:11211'
#  :metastore => 'file:/tmp/cache/rack/meta',
#  :entitystore => 'file:/tmp/cache/rack/body'
