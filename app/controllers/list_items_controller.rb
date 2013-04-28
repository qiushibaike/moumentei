# -*- encoding : utf-8 -*-
class ListItemsController < ApplicationController
  before_filter :find_list
  before_filter :find_item, :except => [:index, :new, :create]
  # GET /list_items
  # GET /list_items.xml
  def index
    @list_items = @list.items.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @list_items }
    end
  end

  # GET /list_items/1
  # GET /list_items/1.xml
  def show
    @list_item = @list.items.find(params[:id],:include => :articles)

    respond_to do |format|
      format.html { 
        redirect_to @list_item.article
      }
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/new
  # GET /list_items/new.xml
  def new
    @list_item = @list.items.new
    @lists = List.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/1/edit
  def edit
    @list_item = ListItem.find(params[:id])
    @lists = List.all
  end

  # POST /list_items
  # POST /list_items.xml
  def create
    @list_item = @list.items.new(params[:list_item])

    respond_to do |format|
      if @list_item.save
        flash[:notice] = 'ListItem was successfully created.'
        format.html { redirect_to(@list_item) }
        format.xml  { render :xml => @list_item, :status => :created, :location => @list_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.xml
  def update

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        flash[:notice] = 'ListItem was successfully updated.'
        format.html { redirect_to(@list_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /list_items/1
  # DELETE /list_items/1.xml
  def destroy
    @item.destroy if current_user == @list.user

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_list
    @list = List.find params[:list_id]
  end

  def find_item
    @item = @list.items.find params[:id]
    @list_item = @item
  end
end
