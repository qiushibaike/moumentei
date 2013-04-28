# -*- encoding : utf-8 -*-
class Admin::TagsController < Admin::BaseController
  before_filter :find_tag, :except => [:index]
  def index
    @tags = Tag.all
  end

  def edit
  end
  
  def update
    if @tag.update_attributes(params[:tag])
      flash[:success] = 'tag updated'
      redirect_to [:edit, :admin, @tag]
    else
      render :action => :edit
    end
  end

  protected
  def find_tag
    @tag = Tag.find_by_name params[:id]
  end
end
