# -*- encoding : utf-8 -*-
class MessagesController < ApplicationController
  before_filter :login_required
  layout 'messages'
  # GET /messages
  # GET /messages.xml
  def index
#    @messages = current_user.messages.all

    respond_to do |format|
      format.html {
        redirect_to inbox_messages_path
      }
      format.mobile {
        redirect_to inbox_messages_path
      }
      format.xml  { render :xml => @messages }
    end
  end

  def inbox
    @messages = current_user.inbox_messages_by_page(params[:page])
    respond_to do |format|
      format.html
      format.mobile 
    end
    @messages.each do |msg|
      unless msg.read
        msg.read = true
        msg.save
      end
    end
  end

  def outbox
    @messages = current_user.outbox_messages_by_page(params[:page])
    respond_to do |format|
      format.html
      format.mobile 
    end
  end
  
  def count
    respond_to do |format|
      format.html
      format.mobile
      #format.wml
    end
  end

  def status
    
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = current_user.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
    if params[:id]
      @user = User.find params[:id]
      if not @user
        flash[:error] = 'Cannot find that user'
        return redirect_to :back
      end
    end
    @message.recipient = @user
    respond_to do |format|
      format.html # new.html.erb
      format.mobile
      format.xml  { render :xml => @message }
    end
  end

#  # GET /messages/1/edit
#  def edit
#    @message = Message.find(params[:id])
#  end

  # POST /messages
  # POST /messages.xml
  def create
    message = params[:message]
    
    message[:sender_id] = message[:owner_id] = current_user.id
    @out_message = Message.new(message)
    @out_message.read = true
    message[:owner_id] = message[:recipient_id].to_i
    @in_message = Message.new(message)
    @in_message.read = false
    respond_to do |format|
      if @in_message.save and @out_message.save
        flash[:notice] = 'Message sent successfully.'
        format.html { redirect_to(:back) }
        format.mobile { redirect_to(:back) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.mobile{ render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
#  def update
#    @message = Message.find(params[:id])
#
#    respond_to do |format|
#      if @message.update_attributes(params[:message])
#        flash[:notice] = 'Message was successfully updated.'
#        format.html { redirect_to(@message) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = 'message deleted successfully'
        redirect_to(:back)
      end
      format.mobile do
        flash[:notice] = 'message deleted successfully'
        redirect_to(:back)
      end
      format.xml  { head :ok }
    end
  end
end
