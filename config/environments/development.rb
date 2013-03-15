# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false
#config.log_level = :any
# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false#true
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :test
#
#config.gem 'memcached'
#
#config.cache_store = :libmemcached_store, "localhost:11211", {
#  :buffer_requests => true,
#}
#config.cache_store = :mem_cache_store, "localhost:11211"
#config.action_controller.session_store = :libmemcached_store
#
#Workling::Remote.dispatcher = Workling::Remote::Runners::SpawnRunner.new
#Workling::Remote.invoker = Workling::Remote::Invokers::EventmachineSubscriber
#Workling::Remote.dispatcher = Workling::Remote::Runners::ClientRunner.new
#Workling::Remote.dispatcher.client = Workling::Clients::AmqpClient.new
##
#config.middleware.use ::Rack::Cache,
#  :verbose => true,
#  :metastore => 'file:/tmp/cache/rack/meta',
#  :entitystore => 'file:/tmp/cache/rack/body'
#config.gem 'awesome_print', :lib => 'ap'
