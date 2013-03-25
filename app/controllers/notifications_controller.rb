# -*- encoding : utf-8 -*-
class NotificationsController < ApplicationController
  before_filter :login_required
  layout 'users'
  # GET /notifications
  # GET /notifications.xml
  def index
    @notifications = current_user.notifications.paginate :page => params[:page], :conditions => {:read => false}
    @count = current_user.notifications.count
    @user = current_user
    @unread_notification_count = current_user.notifications.unread.count
    respond_to do |format|
      format.html {}
      format.mobile { render :layout => 'application'}
      format.js {
        render :json => @notifications
      }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.xml
  def show
    @notification = current_user.notifications.find(params[:id])
    case @notification.key[0]
    when 'new_comment'
      redirect_to article_path(@notification.key[1], :anchor => "comment-#{@notification.content[1]}")
    when 'new_follower'
      redirect_to user_path(@notification.key[1])
    when 'delete_comment'
       redirect_to :back
    end
    @notification.read!
  end

  # GET /notifications/new
  # GET /notifications/new.xml
#  def new
#    @notification = Notification.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @notification }
#    end
#  end

  # GET /notifications/1/edit
#  def edit
#    @notification = Notification.find(params[:id])
#  end

  # POST /notifications
  # POST /notifications.xml
#  def create
#    @notification = Notification.new(params[:notification])
#
#    respond_to do |format|
#      if @notification.save
#        flash[:notice] = 'Notification was successfully created.'
#        format.html { redirect_to(@notification) }
#        format.xml  { render :xml => @notification, :status => :created, :location => @notification }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /notifications/1
#  # PUT /notifications/1.xml
#  def update
#    @notification = Notification.find(params[:id])
#
#    respond_to do |format|
#      if @notification.update_attributes(params[:notification])
#        flash[:notice] = 'Notification was successfully updated.'
#        format.html { redirect_to(@notification) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.xml  { head :ok }
    end
  end
  # delete /notifications/
  def clear
    current_user.notifications.delete_all
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
    end
  end

  def clear_all
    current_user.notifications.all.each { |n|
        n.read!
    }
    @unread_notification_count = current_user.notifications.unread.count
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.js
    end
  end

  def ignore
    @notification = Notification.find(params[:id])
    @notification.read!
    @unread_notification_count = current_user.notifications.unread.count
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.js
    end
  end

end
