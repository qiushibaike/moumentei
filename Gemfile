source 'http://ruby.taobao.org'
gem "rails", "~> 3.2.1"
platforms :ruby, :mingw do
  # use mysql
  gem 'mysql2'
  # use sqlite3
  gem 'sqlite3'
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter', :require => false
  # use sqlite3
  gem 'activerecord-jdbcsqlite3-adapter'
  #gem 'jruby-ehcache', :require => 'ehcache'
  gem 'trinidad', :require => false, :groups => 'production'
end

gem 'will_paginate'
gem "aasm"
gem 'paperclip', '~> 2.0'
gem 'compass'
gem 'SystemTimer', :platforms => :ruby_18
gem 'memcache-client'
gem "oauth"
gem "oauth-plugin"
gem 'delayed_job'
gem 'super_cache'
gem 'eventmachine'
gem 'rufus-scheduler'

gem 'acts_as_list'
gem 'awesome_nested_set'
gem 'themes_for_rails'
gem 'inherited_resources'
gem 'squeel'
gem 'mobile-fu'
gem "calendar_helper"
#gem "rinku", :require => 'rails_rinku', :platforms
gem 'rails_autolink'
gem 'acts_as_favorite', :git => 'https://github.com/ShiningRay/acts_as_favorite.git'
gem 'acts_as_taggable_on_steroids', :git => 'https://github.com/ShiningRay/acts_as_taggable_on_steroids.git', :require => 'acts_as_taggable'
gem 'alias_fallback', :git => 'https://github.com/ShiningRay/alias_fallback.git'
gem "rolify", '~> 3.1'
gem 'thin', :platforms => :ruby

group :development do
  gem 'capistrano'
  gem 'win32console', '~> 1.3.2', :platforms => :mingw
  gem 'jruby-pageant', :require => false, :platforms => :jruby
  gem 'better_errors', :platforms => [:mingw_19, :ruby_19]
  
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'guard-livereload' 
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'rack-livereload'
  gem 'guard-jruby-rspec', :platforms => :jruby
end

group :test do
  gem "factory_girl_rails", "1.7.0"
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', '~> 0.9.1', :require => false
  gem 'rb-fchange', :require => false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'ruby_gntp'
  gem 'quiet_assets'
  gem 'forgery'
  gem 'cucumber-rails', :require => false
end

group :production do
  gem 'rack-cache'
end
