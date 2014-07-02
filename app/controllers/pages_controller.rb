# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :find_group, :only => [:index, :show]
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_with @pages
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_path(params[:path].join('/'))

    return show_404 unless @page

    respond_with @page
  end
end
