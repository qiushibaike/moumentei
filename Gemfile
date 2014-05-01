source 'http://ruby.taobao.org'
gem "rails", "~> 4.0.0"
platforms :ruby, :mingw do
  # use mysql
  gem 'mysql2'
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter', :require => false
  # use sqlite3
  gem 'activerecord-jdbcsqlite3-adapter', :require => false
  #gem 'jruby-ehcache', :require => 'ehcache'
  #gem 'trinidad', :require => false, :groups => 'production'
  gem 'warbler'
end

gem 'puma', :platforms => [:jruby, :ruby]

# rails 3 compatible
gem 'rails-observers'
gem 'protected_attributes'
gem 'rails_autolink'
#
gem 'will_paginate'
gem "aasm"
gem 'paperclip'
gem 'compass'
gem 'dalli'
gem "oauth"
gem "oauth-plugin"
gem 'delayed_job'
gem 'delayed_job_active_record'
#gem "delayed_job_web"
gem 'super_cache'
gem 'rufus-scheduler'
gem 'acts_as_list'
gem 'awesome_nested_set'
gem 'themes_for_rails', github: 'ShiningRay/themes_for_rails'
gem 'inherited_resources'
gem 'squeel'
gem 'mobile-fu'
gem "calendar_helper"
#gem "rinku", :require => 'rails_rinku', :platforms
gem 'acts_as_favorite', :git => 'https://github.com/ShiningRay/acts_as_favorite.git'
gem 'acts_as_taggable_on_steroids', :git => 'https://github.com/ShiningRay/acts_as_taggable_on_steroids.git', :require => 'acts_as_taggable'
gem 'alias_fallback', :git => 'https://github.com/ShiningRay/alias_fallback.git'
gem "rolify", '~> 3.1'
gem 'dynamic_form'

# group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby
  gem 'uglifier', '>= 1.0.3'
  #gem 'turbo-sprockets-rails3'
  # Use jquery as the JavaScript library
  gem 'jquery-rails'
  gem 'jquery-ui-rails'

  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  gem 'turbolinks'
  gem 'jquery-turbolinks'
  gem 'turbolinks-redirect'
# end
gem 'remotipart'
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'win32console', '~> 1.3.2', :platforms => :mingw
  gem 'jruby-pageant', :require => false, :platforms => :jruby
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'guard'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'guard-jruby-rspec', :platforms => :jruby
end

group :test do
  gem "factory_girl_rails"
  gem 'guard-rspec'
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

