# -*- encoding : utf-8 -*-
class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.xml
  layout "users"
   before_filter :login_required
  before_filter :ensure_profile
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
#  def new
#    @profile = Profile.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @profile }
#    end
#  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.xml
#  def create
#    @profile = Profile.new(params[:profile])
#
#    respond_to do |format|
#      if @profile.save
#        format.html { redirect_to(@profile, :notice => 'Profile was successfully created.') }
#        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(user_profiles_path(current_user), :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
#  def destroy
#    @profile = Profile.find(params[:id])
#    @profile.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(profiles_url) }
#      format.xml  { head :ok }
#    end
#  end
  protected
  def ensure_profile
    current_user.profile ? @profile=current_user.profile : @profile=current_user.create_profile
  end
  
end
