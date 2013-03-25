# -*- encoding : utf-8 -*-
class MyController < ApplicationController
  before_filter :login_required
  before_filter :cache_control
  
  def index
    redirect_to current_user
  end

  def chat
    id = request.session_options[:id]
    server='chat.zuikeai.net:8001'
    logger.info HTTParty.get("http://#{server}/create", :query => {:id => id, :nick => current_user.login}).inspect
    redirect_to "http://#{server}?id=#{id}"
  end

  def friends
    @articles = Article.paginate(:page => params[:page], 
      :conditions => {:status => 'publish',
        :anonymous => false,
        :user_id => current_user.friend_ids},
      :order => 'id desc', :include => :score)
  end

  def friends_comments
    @comments = Comment.paginate(:page => params[:page],
      :conditions => {:status => 'publish',
        :anonymous => false,
        :user_id => current_user.friend_ids
      },
      :order => 'id desc')
  end

  def balance
    @balance = current_user.balance
    respond_to do |format|
      format.js {
        render :json => @balance
      }
    end
  end

  def articles
    params[:format] = 'html'
    @articles = Article.paginate :page => params[:page], :conditions => ['user_id = ? and status != ? and status != ?',current_user.id, 'deleted',''],
      :order => 'id desc'
  end

  def favorites
    redirect_to '/favorites'
  end
  
  def resend
    key = "activation:#{current_user.id}"
    if Rails.cache.exist?(key, :raw => true)
      return render :text => '请勿频繁尝试'
    end
    if current_user.pending?
      UserNotifier.signup_notification(current_user).deliver
      render :text => '发送成功请查收，邮件大约在1小时内到达'
      Rails.cache.write(key, '1', :raw => true, :expires_in => 1.hour)
    else
      render :text => '您已激活，无须再次激活'
    end
  #rescue
  end
  
  def rename
    if params[:new_name]
      current_user.rename params[:new_name]
    end
  end
  
  def sendcode
    if params[:email] =~ Authentication.email_regex
      UserNotifier.invitation_code(current_user,params[:email],params[:code]).deliver
      flash[:notice] = '发送成功'
    else
      flash[:error] = '请输入正确的邮箱地址'
    end
    redirect_to invitation_codes_path

  end
  
  protected
  def cache_control
    response.headers['Cache-Control'] = 'no-cache, no-store'
  end
end
