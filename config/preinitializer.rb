# -*- encoding : utf-8 -*-
begin
  require "rubygems" 
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if RUBY_PLATFORM =~ /win32|w32/
  begin
    require 'Win32/Console/ANSI'
  rescue 
    puts 'cannot load win32console' 
  end
end 

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old for Rails 2.3." +
   "Run `gem install bundler` to upgrade."
end

Gem::Deprecate.skip = true 

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end
