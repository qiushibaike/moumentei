# -*- encoding : utf-8 -*-
class BadgesController < ApplicationController
  # GET /badges
  # GET /badges.xml
  def index
    @badges = Badge.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @badges }
    end
  end

  # GET /badges/1
  # GET /badges/1.xml
  def show
    @badge = Badge.find(params[:id])
    @users = @badge.users
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @badge }
    end
  end

  # GET /badges/new
  # GET /badges/new.xml
  def new
    return
    @badge = Badge.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @badge }
    end
  end

  # GET /badges/1/edit
  def edit
    return
    @badge = Badge.find(params[:id])
  end

  # POST /badges
  # POST /badges.xml
  def create
    return
    @badge = Badge.new(params[:badge])

    respond_to do |format|
      if @badge.save
        flash[:notice] = 'Badge was successfully created.'
        format.html { redirect_to(@badge) }
        format.xml  { render :xml => @badge, :status => :created, :location => @badge }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /badges/1
  # PUT /badges/1.xml
  def update
    return
    @badge = Badge.find(params[:id])

    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        flash[:notice] = 'Badge was successfully updated.'
        format.html { redirect_to(@badge) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /badges/1
  # DELETE /badges/1.xml
  def destroy
    return
    @badge = Badge.find(params[:id])
    @badge.destroy

    respond_to do |format|
      format.html { redirect_to(badges_url) }
      format.xml  { head :ok }
    end
  end
end
