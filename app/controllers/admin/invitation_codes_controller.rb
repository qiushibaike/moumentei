# -*- encoding : utf-8 -*-
class Admin::InvitationCodesController < Admin::BaseController
  # GET /invitation_codes
  # GET /invitation_codes.xml
  def index
    @invitation_codes = InvitationCode.paginate :page => params[:page], :order => 'id desc'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitation_codes }
    end
  end
  
  def generate
    InvitationCode.generate current_user.id, params[:amount].to_i
    flash[:notice] = 'generate successfully'
    redirect_to :back
  end

  # GET /invitation_codes/1
  # GET /invitation_codes/1.xml
  def show
    @invitation_code = InvitationCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation_code }
    end
  end

  # GET /invitation_codes/new
  # GET /invitation_codes/new.xml
  def new
    @invitation_code = InvitationCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation_code }
    end
  end

  # GET /invitation_codes/1/edit
  def edit
    @invitation_code = InvitationCode.find(params[:id])
  end

  # POST /invitation_codes
  # POST /invitation_codes.xml
  def create
    @invitation_code = InvitationCode.new(params[:invitation_code])

    respond_to do |format|
      if @invitation_code.save
        flash[:notice] = 'InvitationCode was successfully created.'
        format.html { redirect_to(@invitation_code) }
        format.xml  { render :xml => @invitation_code, :status => :created, :location => @invitation_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitation_codes/1
  # PUT /invitation_codes/1.xml
  def update
    @invitation_code = InvitationCode.find(params[:id])

    respond_to do |format|
      if @invitation_code.update_attributes(params[:invitation_code])
        flash[:notice] = 'InvitationCode was successfully updated.'
        format.html { redirect_to(@invitation_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitation_codes/1
  # DELETE /invitation_codes/1.xml
  def destroy
    @invitation_code = InvitationCode.find(params[:id])
    @invitation_code.destroy

    respond_to do |format|
      format.html { redirect_to(invitation_codes_url) }
      format.xml  { head :ok }
    end
  end
end
