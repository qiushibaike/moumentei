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

group :production do
  gem 'rack-cache'
end
