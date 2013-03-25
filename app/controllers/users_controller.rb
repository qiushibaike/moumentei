# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class UsersController < ApplicationController 
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  skip_before_filter :login_required, :except => [:update, :favorites]

  before_filter :find_user, :only => [:suspend,:comments, :unsuspend, :destroy, :purge, :show, :edit, :update, :followings, :followers, :follow, :unfollow]
  #layout 'users', :except => [:new, :fetchpass, :activate]
  #layout 'application', :only => [:new, :fetchpass, :activate]
  layout 'users'
  #super_caches_page :show
  
  include Reportable
  
  def index
    redirect_to :controller => :my
  end
  
  def show
    if @user.suspended? or @user.deleted?
      return show_404
    end
    respond_to do |format|
      format.any( :html, :mobile) do
        redirect_to user_articles_path(@user)        
      end
      format.js do
        json = @user.as_json(:only => [:id, :login, :name])
        json['user']['followers'] = @user.followers.count
        json['user']['friends']   = @user.friends.count
        json['user']['avatar']    = @user.avatar.url(:thumb)
        json['user']['public_articles_count'] = @user.articles.public.signed.count
        json['user']['charm'] = @user.charm
        if logged_in?
          json['following'] = current_user.following?(@user)
        end
        render :json => json  
      end
    end
  end
  
  def search
    if params[:search] =~ /\#?(\d+)/
      user = User.find_by_id $1
      return redirect_to user if user
    end
    if params[:search].size < 1
      flash[:error] = '请输入要查找的用户名的一部分'
    else
      @users = User.paginate :page => params[:page],
        :conditions => ["login LIKE ?", "%#{params[:search]}%"]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.mobile
      format.xml  { render :xml => @users }
    end
  end
  
  def comments
    return unless @user.state == 'active'
    # return access_denied unless @user.has_role? 'doctor'
    @is_current = (logged_in? and current_user == @user)
    @title_name = @user.login
    if @is_current
      @comments = @user.comments.public.paginate  :order => 'id desc', :page => params[:page]
    else
      @comments = @user.comments.paginate :conditions => ["anonymous <> 1 and status='publish'"], :order => 'id desc', :page => params[:page]
    end
    current_user.clear_notification 'new_follower', @user.id if logged_in?
  end

  def my
    render :json => current_user
  end

  def edit
    return access_denied unless current_user == @user
  end

  def editpass
    if request.post?
      if User.authenticate(current_user.login, params[:old_password])
        current_user.password=params[:password]
        current_user.password_confirmation=params[:password_confirmation]
        if current_user.save
          flash[:error]='设置新密码成功'
        else
          flash[:error]='密码太短或不匹配'
        end
      else
        flash[:error]='原始密码错误'
      end
    end
  end

  def update
    return access_denied unless current_user == @user
    @user.avatar = params[:user][:avatar]
    @user.email = params[:user][:email]
    if @user.save
      flash[:notice] = '更新成功，如果您更改了邮箱请重新激活'
    end
    render :action => :edit
  end
  
  # render new.rhtml
  def new
    #session[:return_to] = request.referer
    @user = User.new
    render :layout => 'register'
  end
 
  def create
    logout_keeping_session!

    @user = User.new(params[:user])
#    if params[:invitation_code]
#      code = InvitationCode.find_by_code(params[:invitation_code].upcase.gsub(/\W/, ''))
#    end

#    unless code
#      flash[:error] = '无效的邀请码'
#      return render :action => :new, :layout => 'application'
#    end
    
#    if code.consumer_id
#      flash[:error] = '邀请码已被使用'
#      return render :action => :new, :layout => 'application'
#    end
    @user.remember_token = ''
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      code.update_attributes :consumer_id => @user.id, :consumed_at => Time.now rescue nil
      @articles = Article.find_all_by_email(@user.email)
      if @articles
        for article in @articles
          article.user_id = @user.id
          article.save
        end
      end
      #redirect_back_or_default(login_path)
      @content_for_title = "注册成功"
      flash[:notice] = "感谢您的注册！<br />请查收我们发给您的邮件激活您的帐号。"
      render :template => 'users/notice', :layout => 'register'      
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new', :layout => 'register'
    end
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "激活成功！<br />您现在可以登录网站了。"
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "激活码有误，请点击激活邮件中的激活链接。"
      redirect_back_or_default('/')
    else 
      flash[:error]  = "激活码已经过期，您可能已经激活成功，请尝试登录网站。如果无法登录，请重新注册。"
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def followings
    @title_name = "#{@user.login}关注的好友"
    @friends = @user.friends
  end

  def followers
    @title_name = "关注#{@user.login}的朋友"
    @followers = @user.followers.paginate :page => params[:page], :per_page=>60

  end
  def check_login
    user=User.find_by_login(params[:user_login])
    render :text => user ? '1' : "0"
  end
  def check_email
    user=User.find_by_email(params[:user_email])
    render :text => user ? '1' : "0"
  end
  def check_invitation_code
    code=params[:invitation_code].upcase.gsub(/\W/, '')
    code=InvitationCode.find :first,:conditions => ["code='#{code}'"]
    if code && !code.consumer_id
      return render  :text=> "激活码可以使用"
    else
      return render  :text=> "无效的激活码"
    end
  end

  def follow
    if current_user != @user
      current_user.follow @user
      a=Notification.find(:first,:conditions=>{:user_id => current_user.id, :key => "new_follower.#{@user.id}", :content => @user.id})
      a.read! unless a.nil?
      Notification.create :user_id => @user.id, :key => "new_follower.#{current_user.id}", :content => current_user.id rescue nil
    end
    respond_to do |format|
      format.any(:html, :mobile)do
        flash[:notice]="您已经关注了#{@user.login}"
        redirect_to :back
      end
      format.js do
        render :json => {:following => true}
      end
    end
  end

  def unfollow
    a=Notification.find(:first,:conditions=>{:user_id => current_user.id, :key => "new_follower.#{@user.id}", :content => @user.id})
    a.read! unless a.nil?
    current_user.unfollow @user

    respond_to do |format|
      format.any(:html, :mobile)do
        flash[:notice]="您已经取消关注了#{@user.login}"
        redirect_to :back
      end
      format.js do
        render :json => {:following => false}
      end
    end
  end
  
  def fetchpass
    if request.post? and params[:id] == "1" # 生成确认邮件
      user = User.reset_password( params )
      if user
        if user.deleted? or user.suspended?
          @msg = "用户状态异常，请联系管理员"
        else
          UserNotifier.fetchpasswd(user,3).deliver
          @msg = "您的密码已经被重置，新密码已发送到您的邮箱#{user.email}，请查收"
          @ret = 'ok'
        end
      else
        @msg = "对不起，没有找到您提供的登录名/Email组合，请确认"
      end
    end
    render :layout => 'application'
  end

  def favorites
    @articles = current_user.favorite_articles.paginate :page => params[:page]
  end

  def lists
    @lists = current_user.lists.find(:all)
  end

  protected
  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    show_404 params[:id]
    return false
  end
end
