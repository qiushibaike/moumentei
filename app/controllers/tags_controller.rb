# -*- encoding : utf-8 -*-
class TagsController < ApplicationController
  def index
    #@tags = Article.tag_counts
    @tags = @group.public_articles.cached_tag_clouds
    respond_to do |format|
      format.html
      format.mobile
      format.json {
        render :json => @tags
      }
    end
  end

  def show
    if @tag
      redirect_to group_tag_articles_path(@group, @tag.name)
    else
      render :text => 'no such tag', :status => :not_found
    end
  end

#  def new
#
#  end
#
#  def edit
#
#  end
  protected
  def find_tag
    @tag = Tag.find_by_name params[:id]
    @tag = Tag.find params[:id] if not @tag and params[:id] =~ /\A\d+\z/
  end
  before_filter :find_tag, :except => [:index, :new, :create]
  before_filter :find_group
end
