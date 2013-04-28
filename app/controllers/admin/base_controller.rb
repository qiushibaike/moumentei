# -*- encoding : utf-8 -*-
class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  def admin_required
    access_denied unless logged_in? and current_user.is_admin?
  end
end
