module ThemeSupport
  module ControllerMethod
    def theme_support
      include ThemeSupport::ControllerExtensions
      helper :theme
    end
  end
end
require 'theme_support/controller_extensions'
require 'theme_support/routing_extensions'
require 'theme_helper'
ActionController::Base.extend(ThemeSupport::ControllerMethod)
ActionController::Routing::RouteSet::Mapper.send :include, ThemeSupport::RoutingExtensions
