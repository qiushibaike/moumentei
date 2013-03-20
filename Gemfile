source 'http://ruby.taobao.org'
gem "rails", "~> 3.2.1"
gem 'mysql2' , :platforms => [:ruby, :mingw]
gem 'sqlite3'

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter', :require => false
end

gem 'will_paginate'
gem "aasm"
gem 'paperclip', '~> 2.0'
gem 'compass'
gem 'SystemTimer', :platforms => :ruby
gem 'memcache-client'
gem "oauth"
gem "oauth-plugin"
gem 'delayed_job'
gem 'super_cache'

group :development do
  gem 'capistrano'
  gem 'win32console', '~> 1.3.2', :platforms => :mingw
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
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
end

group :production do
  gem 'rack-cache'
end
