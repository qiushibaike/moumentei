# Initializes theme support by extending some of the core Rails classes
require 'theme_support'
#ActionMailer::Base.send(:include, ThemeSupport::ControllerExtensions)

# Add the tag helpers for rhtml and, optionally, liquid templates
#require 'helpers/rhtml_theme_tags'

# Commented out to remove the message 
# "Liquid doesn't seem to be loaded...  uninitialized constant Liquid"

#begin
#   require 'helpers/liquid_theme_tags'   
#rescue
#   # I guess Liquid isn't being used...
#   STDERR.puts "Liquid doesn't seem to be loaded... #{$!}"
#end
