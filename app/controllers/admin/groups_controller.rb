# -*- encoding : utf-8 -*-
class Admin::GroupsController < Admin::BaseController
  # GET /keywords
  # GET /keywords.xml
  def index
    @groups = Group.roots

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /keywords/1
  # GET /keywords/1.xml
  def show
    @group = Group.find params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /keywords/new
  # GET /keywords/new.xml
  def new
    @group = Group.new
    @group.options ||= {}

    respond_to do |format|
      format.html { render :action => :new}
      format.xml  { render :xml => @group }
    end
  end

  # GET /keywords/1/edit
  def edit
    @group = Group.find(params[:id])
    @group.options ||= {}
  end

  # POST /keywords
  # POST /keywords.xml
  def create
    unless params[:group][:parent_id].blank?
      parent = Group.find_by_id params[:group][:parent_id]
    end
    @group = Group.new(params[:group])


    respond_to do |format|
      if @group.save
        @group.move_to_child_of parent if parent
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to admin_groups_path }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /keywords/1
  # PUT /keywords/1.xml
  def update
    @group = Group.find params[:id]
    params[:group].each_pair do |k,v|
      params[:group].delete(k) if v.blank?
    end
    parent_id = params[:group][:parent_id]

    if parent_id.blank?
      params[:group].delete :parent_id
      @group.move_to_root
    else
      begin
        @group.move_to_child_of Group.find(parent_id.to_i)
      rescue
        flash[:error] = 'Cannot move into that group'
        return render(:template => 'admin/groups/edit')
      end
    end
    if @group.update_attributes params[:group]
      redirect_to admin_groups_path
    else
      render :template => 'admin/groups/edit'
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(admin_groups_url) }
      format.xml  { head :ok }
    end
  end

  def moveup
    @group = Group.find params[:id]
    @group.move_left if @group.left_sibling
    redirect_to admin_groups_path
  end

  def movedown
    @group = Group.find params[:id]
    @group.move_right if @group.right_sibling
    redirect_to admin_groups_path
  end
end
