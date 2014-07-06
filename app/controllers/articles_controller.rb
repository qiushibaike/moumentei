# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController
  #before_filter :oauthenticate, only: [:create]
  before_filter :find_group, except: :index
  before_filter :find_article, except: [:index, :new, :create, :scores]
  after_filter :store_location, except: [:up, :dn, :score, :scores]
  #super_caches_page :show
  cache_sweeper :article_sweeper, only: [ :create ]
  has_scope :hottest_by, default: 'all', allow_blank: true, only: :index
  has_scope :latest, type: :boolean, only: :index
  has_scope :recent_hot, type: :boolean, only: :index

  decorates_assigned :article, :articles, :comments, :group

  def index
    if params[:user_id]
      @user = User.find params[:user_id]
      @articles = apply_scopes(@user.articles.public.signed).paginate page: params[:page]
    else
      find_group
      g =  @group.self_and_children_ids
      @articles = apply_scopes(Article.by_group(g).public).paginate(page: params[:page])
      # if @articles.size == 0 && @articles.total_pages < @articles.current_page
      #   params[:page] = @articles.total_pages
      #   return redirect_to(params)
      # end
    end

    respond_with articles
  end

  def new
    return redirect_to login_path if @group.options[:only_member_can_post] and not logged_in?
    @article = @group.articles.new
  end

  def create
    error_return = Proc.new do |msg|
      respond_to do |format|
        format.any(:html, :mobile) {
          if request.xhr?
            render text: msg
          else
            flash[:error] = msg
            render action: 'new'
          end
        }
        format.js{
          render json: {error: msg}, status: :unprocessable_entity
        }
      end
      return
    end

    @article = article = Article.new(article_params)
    @article.group_id = @group.id if not @article.group_id or @article.group_id == 0
    if @group.only_member_can_post? and not logged_in?
      error_return.call('Only registered members can post in this group')
    end
    article.content.strip! # trim the whitespace in the end or beginning
    if not logged_in?
      error_return.call('内容太长了，请不要超过500个字')
    end

    #article.picture.clear unless logged_in?
    unless article.content.blank?
    hsh = Digest::MD5.hexdigest "#{article.title}#{article.content}"

    if hsh == session[:last_content]
      error_return.call("请不要发表重复内容")
    end

    session[:last_content] = hsh

    end
    if logged_in?
      @article.user_id = current_user.id
      @article.anonymous = true if @group.force_anonymous?
    else
      @article.user_id = 0
      @article.anonymous = true
    end
    if @article.content.blank? and not @article.picture.file?
      error_return.call("文章内容太短")
    end

    @article.status= @group.articles_need_approval? ? 'pending' : 'publish'
    @article.status= 'pending' if @article.user_id == 0

    if @article.save
      if logged_in?
        current_user.has_favorite @article rescue nil
      end
      respond_to do |format|
        format.any(:html, :mobile) {
          if @article.status == 'publish'
            redirect_to article_path(@article)
          else
            render action: 'new'
          end
        }
        format.js{
          render nothing: true, status: :created
        }
      end
    end
    #Article.push_consult @article.id if params[:counseling] == '1'
  end

  def show
    @comments = @article.comments.public
    respond_with article
  end

  # def tickets_stats
  #   @tickets = {}
  #   @article.tickets.each do |t|
  #     i = t.ticket_type_id.to_i
  #     @tickets[i] ||= 0
  #     @tickets[i] += 1
  #   end
  #   @ticket_types = TicketType.all
  #   render layout: false
  # end

  def dn
    vote(-1)
  end

  def up
    vote 1
  end

  def move
    if current_user.has_role?('admin') or current_user.has_role?('moderator')
      @article.group_id = params[:group_id]
      @article.score.group_id = params[:group_id]
      @article.save!
      @article.score.save!
    end
    redirect_to :back
  end

  def destroy
    if current_user == @article.user or current_user.has_role?('admin') or current_user.has_role?('moderator')
      @article.destroy
    end
    redirect_to '/'
  end


  def ref
    if @article.references.empty?
      flash[:notice] = "#{@article.group.name}\##{params[:id]} 没有相关帖子"
      redirect_to :back
    else
      @articles = @article.public_references.paginate page: params[:page]
      @articles.unshift(@article)
      @title_name = '相关文章'
      render( template: "groups/archives" )
    end
  end

  # def add_favorite
  #   return redirect_to(login_path) if not logged_in? or current_user.id == 0
  #
  #   current_user.has_favorite @article
  #
  #   if request.xhr?
  #     render layout: false
  #   else
  #     redirect_to article_path(@article)
  #   end
  # end
  #
  # def remove_favorite
  #   return redirect_to(login_path) if not logged_in? or current_user.id == 0
  #   @favorite = Favorite.find :first, conditions: {user_id:current_user.id, favorable_id: @article.id}
  #   @favorite.destroy if @favorite
  #
  #   if request.xhr?
  #     render layout: false
  #   else
  #     redirect_to article_path(@article)
  #   end
  # end

  protected
  # find correct article according to "id" get params
  def find_article
    @article = @group.articles.find(params[:id])
    # if !@group.domain.blank? && request.host != 'localhost' && Rails.env.production?
    #   select_domain @group
    # end
  end

  def vote score
    if logged_in?
      current_user.rate(@article, score)  unless current_user.has_rated?(@article)
    elsif @group.options[:allow_anonymous_vote]
      AnonymousRating.vote(request.remote_ip, @article, score)
    end

    respond_to do |format|
      format.any(:html, :mobile)do
        if request.xhr?
          render text: score
        else
          if params[:return]
            redirect_to params[:return]
          else
            referer = request.env["HTTP_REFERER"]
            if not referer.is_a?(String) or referer.index("http://#{@group.domain}") != 0
              redirect_to article_path(@article)
            else
              redirect_to referer
            end
          end
        end
      end
      format.json do
        render json: score
      end
      format.js
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :content, :anonymous, :picture)
  end
end
