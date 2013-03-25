# -*- encoding : utf-8 -*-
class Admin::BaseController < ApplicationController
  protect_from_forgery
  layout 'admin'
  require_role "admin"
end
