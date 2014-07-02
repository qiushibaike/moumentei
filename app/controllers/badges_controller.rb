# -*- encoding : utf-8 -*-
class BadgesController < ApplicationController
  # GET /badges
  # GET /badges.xml
  def index
    @badges = Badge.all
    respond_with @badges
  end

  # GET /badges/1
  # GET /badges/1.xml
  def show
    @badge = Badge.find(params[:id])
    @users = @badge.users
    respond_with @badge
  end
end
