# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class FavoritesController < ApplicationController
  before_filter :login_required
#  layout 'users'
  def index
    @favorites = Favorite.paginate :page => params[:page], :per_page => 5,
      :conditions => ['user_id = ?', current_user.id],
      :include => :favorable,
      :order => 'favorites.updated_at desc'
    @all_comments = {}
    @articles = []
    @favorites.each do |f|
      a = f.favorable
      @articles << a
      @all_comments[a.id] = a.public_comments.find :all, :conditions => ['created_at > ?', f.created_at]
    end
    render
    t = Time.now
    @favorites.each do |f|
      f.update_attribute :created_at, t
    end
  end

  def new
    
  end
  
  def create
    @favorite = Favorite.new params[:favorite]
    @favorite.user = current_user
    @favorite.save
  end

  def destroy
    @favorite = Favorites.find params[:id]
    @favorite.destroy if @favorite.user_id == current_user.id
  end

  def edit
    
  end

  def update
    
  end

  protected
end
