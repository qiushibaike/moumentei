# -*- encoding : utf-8 -*-
class Tags::ArticlesController < ArticlesController
  before_filter :find_group
  before_filter :find_tag
  
  def index
    if params[:order] == 'hottest'
      opt = Article.find_options_for_find_tagged_with @tag.name,
          :select => 'articles.*',
          :order => 'score DESC'
    else
      opt = Article.find_options_for_find_tagged_with @tag.name,
        :select => 'articles.*',
        :order => params[:order] == 'latest' ? 'articles.created_at DESC' : 'articles.created_at asc'
    end
    
    opt[:page] = params[:page]   
    opt[:include] = :user
    
    @articles = @group.articles.public.paginate opt
    #@group.public_articles.paginate :page => params[:page], :conditions => ['cached_tag_list LIKE ?', "%#{params[:tag]}%"]
    
    #render :template => 'articles/index'
  rescue ArgumentError
    show_404 params[:id]    
  end
  
  def find_tag
    @tag = Tag.find_by_name params[:tag_id]
    @current_tag = @tag.name
  end
end
