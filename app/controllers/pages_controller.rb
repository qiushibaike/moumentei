# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :find_group, :only => [:index, :show]
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_path(params[:path].join('/'))

    return show_404 unless @page

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end
end
