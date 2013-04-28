# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::BaseController
  before_filter :find_user, :except => [:index, :new, :create]

  def index
    if params[:search]
      str="%#{params[:search]}%"
      @users = User.paginate :page => params[:page],
        :conditions => ["id=? or login LIKE ? ",params[:search].to_i,str]
    else
      cond = {}
      cond[:state] = params[:state] if params[:state]
      @users = User.paginate :page => params[:page], :conditions => cond
    end
  end

  def show

  end

  def edit

  end

  def update
    @user.state = params[:user][:state] unless params[:user][:state].blank?
    @user.update_attributes params[:user]    
    @user.badge_ids = params[:user][:badge_ids]
    @user.role_ids  = params[:user][:role_ids]
    @user.weight.update_attribute("adjust",params[:user][:adjust])
    flash[:notice] = "User #{@user.id} updated"
    redirect_to admin_user_path(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user.save
    redirect_to admin_user_path(@user)
  end
  def active
    AuditLogger.log current_user, 'active', @user.id, @user.login
    @user.activate!
    redirect_to admin_users_path
  end

  def suspend
    AuditLogger.log current_user, 'suspend', @user.id, @user.login
    @user.suspend!
    redirect_to admin_users_path
  end

  def unsuspend
    AuditLogger.log current_user, 'unsuspend', @user.id, @user.login
    @user.unsuspend!
    redirect_to admin_users_path
  end

  def destroy
    AuditLogger.log current_user, 'delete', @user.id, @user.login
    @user.delete!
    redirect_to admin_users_path
  end

  def purge
    AuditLogger.log current_user, 'purge', @user.id, @user.login
    @user.destroy
    redirect_to admin_users_path
  end

  def delete_avatar
    if request.post?
      AuditLogger.log current_user, 'delete avatar', @user.id, @user.login
      @user = User.find params[:id]
      @user.avatar = nil
      @user.save
      redirect_to admin_users_path
      #flash[:notice] = "#{@user.id} #{@user.login}的头像已被删除"
    end
  end

  def delete_comments
    if request.post?
      AuditLogger.log current_user, 'delete comments', @user.id, @user.login
      @user = User.find params[:id]
      @comments=@user.comments.all
      @comments.each do |comment|
        comment.status='private'
        comment.save
      end
      redirect_to admin_users_path
      # flash[:notice] = "#{@user.id} #{@user.login}的头像已被删除"
    end
  end
  def comments
    @comments=@user.comments
  end
  def tickets
    @tickets=@user.tickets.paginate :page => params[:page],:per_page=>20
  end

  protected
  def find_user
    @user = User.find params[:id]
  rescue ActiveRecord::NotFound
    flash[:error] = 'Cannot find such user'
    redirect_to admin_users_path
  end
end
