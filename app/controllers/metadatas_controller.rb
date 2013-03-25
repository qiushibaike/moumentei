# -*- encoding : utf-8 -*-
class MetadatasController < ApplicationController
  def index
    @metas = {}
    @article.metadatas.find_each do |m|
      @metas[m.key] = m.value
    end
    respond_to do |format|
      format.json{
        render :json => @metas
      }
    end
  end

  def show
    m = @article.metadata.find_by_key(params[:id])
    return show_404 unless m
    respond_to do |format|
      format.json{
        render :json => {m.key => m.value}
      }
    end
  end

  def new
  end

  def edit
  end
  before_filter :find_article
  def find_article
    @article = Article.find params[:article_id]
  end
end
