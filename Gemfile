source 'http://ruby.taobao.org'
gem "rails", "~> 2.3.5"
platforms :ruby, :mingw do
  # use mysql
  gem 'mysql2', '~> 0.2.6' 
  gem 'activerecord-mysql2-adapter'
  # use sqlite3
  gem 'sqlite3'
end
platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter', :require => false
  # use sqlite3
  gem 'activerecord-jdbcsqlite3-adapter'
end

gem 'will_paginate', '~> 2.3.2'
gem "aasm"
gem 'paperclip'
gem 'compass'
gem 'SystemTimer', :platforms => :ruby
gem 'memcache-client'
gem 'httparty'
gem "oauth"
gem "oauth-plugin"
gem 'delayed_job', '~> 2.0.4', :git => 'git://github.com/collectiveidea/delayed_job.git', :branch => 'v2.0'
gem 'searchlogic'
gem 'super_cache'
gem 'eventmachine'
gem 'rufus-scheduler'

group :development do
  gem 'capistrano'
  gem 'win32console', '~> 1.3.2', :platforms => :mingw
end

group :production do
  gem 'rack-cache'
end
