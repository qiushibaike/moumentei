# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :cache_control
  after_filter :cache_control
  layout 'sessions'
  # get current session
  def show
    return render :nothing => true unless logged_in?
    va = current_user.as_json(:only => [:id, :login, :state])
    va['unread_messages_count'] = current_user.unread_messages_count
    va['unread_notifications_count'] = current_user.notifications.unread.count
    va['flash'] = flash unless flash.empty?

    #    va['notifications_count'] = current_user.notifications.count
    #    va['notifications'] = [current_user.notifications.first]
    cookies['user'] = {:value => va.to_json, :expires => 10.minutes.from_now}
    respond_to do |format|
      format.html
      format.mobile
      format.js {
        render :json => va
      }
    end
  end

  # render new.rhtml
  def new
    #session[:return_to] = request.referer
    respond_to do |format|
      format.any( :html, :mobile) do
        render :layout => false if request.xhr?
      end
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      json = current_user.to_json(:only => [:id, :login, :state])
      handle_remember_cookie! new_cookie_flag
      cookies['user'] = {:value => json, :expires => 10.minutes.from_now}

      respond_to do |format|
        format.any(:html,:mobile){
          redirect_back_or_default('/favorites')
        }
        format.js {
          va = current_user.as_json(:only => [:id, :login, :state])
          va['unread_messages_count'] = user.unread_messages_count
          va['unread_notifications_count'] = user.notifications.unread.count
          va['flash'] = flash unless flash.empty?
          render :json => va
        }
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      respond_to do |format|
        format.any(:html, :mobile){
          flash[:error] = "错误的用户名/密码组合"
          render :action => 'new', :status => :forbidden
        }
        format.js {
          render :json => {:error => "错误的用户名/密码组合"}, :status => :forbidden
        }
      end
    end
  end

  def destroy
    logout_killing_session!
    # flash[:notice] = "You have been logged out."
    cookies.delete 'user'
    respond_to do |format|
      format.any( :html, :mobile ){
        redirect_back_or_default('/')
      }
      format.js {
        render :nothing => true
      }
    end
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  def cache_control
    response.headers['Cache-Control'] = 'private, no-cache, no-store'
  end
end
