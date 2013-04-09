# -*- encoding : utf-8 -*-
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.log_level = :debug
config.action_view.cache_template_loading = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

#config.gem 'memcached'
#
#config.cache_store = :libmemcached_store, "localhost:11211", {
##  :use_udp => true,
##  :binary_protocol => true,
#  :buffer_requests => true,
#  :retry_timeout => 3,
#  :server_failure_limit => 10,
#  :no_block => true,
##  :show_backtraces => true,
#  }
#config.action_controller.session_store = :libmemcached_store
#
#Workling::Remote.dispatcher = ::Workling::Remote::Runners::ClientRunner.new
#
#
#begin
#Workling::Clients::SyncAmqpClient.client_class = ::Carrot
#Workling::Remote.dispatcher.client = ::Workling::Clients::SyncAmqpClient.new
#Workling::Return::Store.instance = ::Workling::Return::Store::SyncAmqpReturnStore.new
#rescue => e
#  puts e
#  puts e.backtrace.join("\n")
#end
#
