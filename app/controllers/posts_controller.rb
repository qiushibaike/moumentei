# -*- encoding : utf-8 -*-
class PostsController < ApplicationController
  before_filter :login_required
  before_filter :find_user, :only => [:show,:index, :edit, :update, :destroy]
  
  def index
    unless @user
      @user = current_user
      @posts = Post.find :all, :conditions => ['((`posts`.`reshare` = 1 or  `posts`.`parent_id` IS NULL) AND `posts`.`user_id` IN (?))',@user.friend_ids + [@user.id]], :order => 'id desc'
    else
      @posts = @user.posts.find :all, :order => 'id desc'
    end
    
    @post = current_user.posts.new

    respond_to do |format|
      format.html # index.html.erb
      #format.mobile
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.mobile
      format.js { render :json => @post }
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = current_user.posts.new
    #    redirect_to posts_path unless current_user==@user
    if params[:parent_id]
      @parent = Post.find params[:parent_id]
      @post.parent = @parent
    end
    respond_to do |format|
      format.html
      format.mobile
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    return unless @post.user==current_user
  end

  # POST /posts
  # POST /posts.xml
  def create
    @user = current_user
    @post = current_user.posts.new(params[:post])
    @parent = Post.find_by_id @post.parent_id
    @post.parent_id = nil unless @parent
    @post.reshare = false
    respond_to do |format|
      if @post.save
        if params[:post_to] and params[:post_to].is_a?(Array)
          @articles = @post.post_to params[:post_to], params[:anonymous]
        end
        format.any(:html, :mobile){ 
          if request.xhr?
            render :update do |page|
              page.insert_html :top, :posts, :partial => 'post', :object => @post
              #              page.replace_html 'posts'
              #              page[:post_id].reset
            end
          else
            flash[:notice] = 'Post was successfully created.'
            if @articles
              @articles.each do |a|
                flash[:notice] << "Your post has been sent to #{@article.group.name}, id is \##{@article.id};"
              end
            end
            redirect_to(posts_path)
          end
        }
        format.js {
           render :json => @post, :status => :created, :location => @post 
        }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.js  { render :json => @post.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def children
    @post = Post.find params[:id]
    @posts = @post.children
    respond_to do |format|
      format.any(:html, :mobile) do 
        render :layout => false if request.xhr?
      end
      format.js do
        render :json => @posts.as_json(:exclude => [:ip])
      end
    end
  end

  def reshare
    @post = Post.find params[:id]
    current_user.posts.create :parent_id => @post.id, :reshare => true
    redirect_to posts_path
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(user_posts_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy if @post.user_id == current_user.id
    respond_to do |format|
      format.html {
        flash[:notice]='Post was successfully deleted'
        redirect_to(user_posts_path(current_user))}
      format.xml  { head :ok }
    end
  end
  protected

  def find_user
    @user = User.find_by_id params[:user_id]
    #@user = current_user
  end
end


