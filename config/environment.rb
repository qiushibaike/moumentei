# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION
$KCODE='UTF-8'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
if RUBY_PLATFORM =~ /java/
    #require 'rubygems'
    RAILS_CONNECTION_ADAPTERS = %w(jdbc)
end
Rails::Initializer.run do |config|
  config.action_controller.session = {
    :key => '_session_id',
    :secret      => '284ea6a3749dae76ac734366ee8677de126b50d0f5d3d1343456745cf09ea58eeab0ba19458456767897ee871b3ff053260a74dbd879c0'
  }
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  config.autoload_paths += %W( #{RAILS_ROOT}/app/workers #{RAILS_ROOT}/app/mailers )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql
  config.i18n.default_locale = :zh
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = [:user_observer]

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end
