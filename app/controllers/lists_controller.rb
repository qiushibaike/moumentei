# -*- encoding : utf-8 -*-
class ListsController < ApplicationController
  before_filter :find_list, :except => [:index, :new, :create]
  before_filter :login_required, :except => [:index, :show]
  # GET /lists
  # GET /lists.xml
  def index
    @lists = List.all

    respond_to do |format|
      format.html # index.html.erb
      format.mobile
      format.xml  { render :xml => @lists }
    end
  end

  # GET /lists/1
  # GET /lists/1.xml
  def show
    @list = List.find(params[:id])
    @articles = @list.articles.paginate :page => params[:page],:order => :position

    respond_to do |format|
      format.html # show.html.erb
      format.mobile
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.xml
  def new
    @list = current_user.lists.new

    respond_to do |format|
      format.html # new.html.erb
      format.mobile
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = current_user.lists.find(params[:id])
  end

  # POST /lists
  # POST /lists.xml
  def create
    @list = current_user.lists.new(params[:list])

    respond_to do |format|
      if @list.save
        flash[:notice] = 'List was successfully created.'
        format.html { redirect_to(@list) }
        format.mobile { redirect_to(@list) }
        format.xml  { render :xml => @list, :status => :created, :location => @list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.xml
  def update
    if @list.user != current_user
      return
    end
    respond_to do |format|
      if @list.update_attributes(params[:list])
        flash[:notice] = 'List was successfully updated.'
        format.html { redirect_to(@list) }
        format.mobile { redirect_to(@list) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.mobile  { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.xml
  def destroy
    if @list.user != current_user
      return
    end
    @list.destroy

    respond_to do |format|
      format.html { redirect_to(lists_url) }
      format.mobile { redirect_to(lists_url) }
      format.xml  { head :ok }
    end
  end

  def append
    if @list.user != current_user
      return render :text=>'access denied', :status => :forbidden
    end
    @article = Article.find params[:article_id].gsub('#', '')

    if @article.status != 'publish'
      flash[:error] = '该文章无法公开'
    elsif @article.group.options[:encryption]
      flash[:error] = '该文章无法公开!'
    else
      @list.items.create :article_id => @article.id
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = '未找到该文章'
  ensure
    redirect_to :back
  end
  
  def sort
    params[:items].each_with_index do |id ,index|
      @list.items.update_all(['position=?',index+1],['id=?',id])
    end
    render :nothing=>true
    #@list
  end
  def created_or_append
    if params[:list_id]
      @list = List.find params[:list_id]
    else
      @list = current_user.lists.create
    end
    render :nothing=>true
    #@list
  end
protected
  def find_list
    @list = List.find(params[:id])
  end
end
