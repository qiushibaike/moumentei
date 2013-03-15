$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'preferences/version'

Gem::Specification.new do |s|
  s.name              = "preferences"
  s.version           = Preferences::VERSION
  s.authors           = ["Aaron Pfeifer"]
  s.email             = "aaron@pluginaweek.org"
  s.homepage          = "http://www.pluginaweek.org"
  s.description       = "Adds support for easily creating custom preferences for ActiveRecord models"
  s.summary           = "Custom preferences for ActiveRecord models"
  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- test/*`.split("\n")
  s.rdoc_options      = %w(--line-numbers --inline-source --title preferences --main README.rdoc)
  s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc LICENSE)
  
  s.add_development_dependency("rake")
  s.add_development_dependency("plugin_test_helper", ">= 0.3.2")
end
