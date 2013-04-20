# -*- encoding : utf-8 -*-
class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  def admin_required
    request.headers.each do |k,v|
      logger.debug "#{k}: #{v}"
    end
    logger.debug cookies.inspect
    logger.debug cookies[:_moumentei_session].inspect
    cookies.each do |k,v|
      logger.debug [k,v].inspect
    end
    logger.debug session.inspect
    logger.debug session[:user_id].inspect
    logger.debug current_user.inspect
    access_denied unless logged_in? and current_user.is_admin?
  end
end
