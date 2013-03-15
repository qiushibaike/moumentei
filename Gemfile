#source :gemcutter
source 'http://ruby.taobao.org'
gem "rails", "~> 2.3.5"
gem 'mysql', :platforms => [:ruby, :mingw]

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter', :require => false
end

gem 'will_paginate', '~> 2.3.2'
gem "aasm"
# Add eventmachine and amqp gems togem to get config.gem goodies:
#gem "eventmachine"
#gem "amqp"

#gem 'ohm'
gem 'paperclip'
gem 'compass'
gem 'mini_magick'
gem "thinking-sphinx",'~> 1.4.10', :platforms => [:ruby]
gem 'data_fabric'
#gem 'acts_as_archive'
gem 'SystemTimer', :platforms => :ruby
gem 'memcache-client'
gem 'httparty'
gem "oauth"
gem "oauth-plugin"
gem 'delayed_job', '~> 2.0.4', :git => 'git://github.com/collectiveidea/delayed_job.git', :branch => 'v2.0'
gem 'searchlogic'
#gem 'sprinkle'
gem 'newrelic_rpm'
gem 'whenever', :require => false

group :development do
  gem 'mongrel'
  gem 'rdoc'
  gem 'capistrano'
  gem 'win32console', '~> 1.3.2', :platforms => :mingw
end

group :production do
  gem 'rack-cache'
  gem 'exception_notification', :git => 'git://github.com/rails/exception_notification.git', :branch => '2-3-stable'
end
