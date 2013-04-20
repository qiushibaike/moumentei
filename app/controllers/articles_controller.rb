# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController
  #before_filter :oauthenticate, :only => [:create]
  before_filter :find_article, :except => [:index, :new, :create, :scores]
  after_filter :store_location, :except => [:up, :dn, :score, :scores]
  #super_caches_page :show
  cache_sweeper :article_sweeper, :only => [ :create ]

  include Reportable

  KEYS = %w(day week month year all)

  DateRanges = {
    '8hr' => 8.hour,
    'day' => 1.day,
    'week' => 1.week,
    'month' => 1.month,
    'year' => 1.year
  }

  def index
    if params[:user_id]
      @user = User.find params[:user_id]
      @articles = @user.articles.public.where{created_at<Time.now}.paginate :page => params[:page], :conditions => {:anonymous => false}, :order => 'id desc'
    else
      find_group
      g =  @group.self_and_children_ids
      @articles = Article.by_group(g).public.latest.paginate(:page => params[:page])
      if @articles.size == 0 && @articles.total_pages < @articles.current_page
        params[:page] = @articles.total_pages
        return redirect_to(params)
      end
    end

    respond_to do |format|
      format.any(:html, :mobile) do
      end
      format.xml {render :xml=> @articles}
      format.json do
        render :json => @articles
      end
      format.rss do
        @articles.collect! do |item|
          {
            :title       => "#{item.group.name.mb_chars[0,2]}\##{item.id} - #{item.content.mb_chars[0,30].gsub(/\r?\n/," ")}...",
            :link        => article_url(item.id),
            :description => render_to_string(:partial => 'common/rss_item', :object => item),
            :pubDate     => item.created_at,
            :guid        => article_url(item.id)
          }
        end
        render_feed :items => @articles, :title=> "#{@user.login}发表的文章"
      end
    end
  end

  def new
    find_group(params[:group_id])
    return redirect_to login_path if @group.options[:only_member_can_post] and not logged_in?
    @article = Article.new :group_id => @group.id
  end

  def create
    find_group(params[:group_id])
    error_return = Proc.new do |msg|
      respond_to do |format|
        format.any(:html, :mobile) {
          if request.xhr?
            render :text => msg
          else
            flash[:error] = msg
            render :action => 'new'
          end
        }
        format.js{
          render :json => {:error => msg}, :status => :unprocessable_entity
        }
      end
      return
    end

    @article = article = Article.new( params[:article])
    @article.group_id = @group.id if not @article.group_id or @article.group_id == 0
    if @group.only_member_can_post? and not logged_in?
      error_return.call('Only registered members can post in this group')
    end
    article.content.strip! # trim the white space in the end or beginning

    if article.content.mb_chars.size > 500 and not logged_in?
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

    @article.tag_list = @article.tag_line
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
            render :action => 'new'
          end
        }
        format.js{
          render :nothing => true, :status => :created
        }
      end
    end
    #Article.push_consult @article.id if params[:counseling] == '1'
  end

  def score
    s = Score.find_by_article_id params[:id]
    respond_to do |format|
      format.js { render :json => s }
    end
  end

  # Please Refer to ScoreMetal
  def scores
    ids = params[:ids].split(/ /).collect{|i|i.to_i}
    s = Article.find_all_by_id(ids)
    if logged_in?
      rated= current_user.has_rated?(ids)
      watched = current_user.has_favorite?(ids)
    end
    m = {}
    s.each do |r|
      id = r.article_id
      json = r.as_json(:only=>[:group_id, :pos, :neg, :score])
      if logged_in?
        json['rated'] = rated[id]
        json['watched'] = !!watched[id]
      end
      m[id] = json
    end
    render :json => m
  end

  def show
    if @article.status == 'publish'
      t = @article.updated_at
      t = Time.parse(t) if t.is_a?(String)
      opt = {
        :last_modified => t.utc,
        :etag => [@article, request.format]}
      if is_mobile_device?
        opt[:public] = false
        if logged_in?
          opt[:etag] << current_user.id
          expires_now
        end
      else
        #opt[:public] = true
        if logged_in?
          opt[:etag] << current_user.id
        end
      end

      if stale?(opt)
        @cache_subject = @article
        respond_to do |format|
          format.html {
            @comments = @article.comments.public.find :all, :order => 'id asc'
            render :action => :show
          }

          format.mobile{
            render :action => :show
          }

          format.js {
            o = {:except => [:ip, :email]}
            o[:except] << :user_id if @article.anonymous?
            render :json => @article.as_json(o)
          }
        end
      end
    else
      render :template => 'articles/not_found', :status => 404
    end
    #current_user.clear_notification(:new_comment, @article.id) if logged_in?
  end

  def tickets_stats
    @tickets = {}
    @article.tickets.each do |t|
      i = t.ticket_type_id.to_i
      @tickets[i] ||= 0
      @tickets[i] += 1
    end
    @ticket_types = TicketType.all
    render :layout => false
  end

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

  def anonymous
    return if current_user != @article.user
    @article.anonymous = !@article.anonymous
    @article.save!
    redirect_to :back
  end

#  def votes
#    return redirect_to(login_path) unless logged_in?
#
#    params[:ids].split(' ').each do |i|
#      i = i.to_i
#      if i < 0
#        d, s = :down, -1
#      else
#        d, s = :up, 1
#      end
#      i = i.abs
#      ScoreWorker.async_vote(:action => d, :id => i)
#      current_user.rate(i, s)
#    end
#    render :nothing => true
#  end

  def ref
    if @article.references.empty?
      flash[:notice] = "#{@article.group.name}\##{params[:id]} 没有相关帖子"
      redirect_to :back
    else
      @articles = @article.public_references.paginate :page => params[:page]
      @articles.unshift(@article)
      @title_name = '相关文章'
      render( :template => "groups/archives" )
    end
  end

  def add_favorite
    return redirect_to(login_path) if not logged_in? or current_user.id == 0

    current_user.has_favorite @article

    if request.xhr?
      render :layout => false
    else
      redirect_to article_path(@article)
    end
  end

  def remove_favorite
    return redirect_to(login_path) if not logged_in? or current_user.id == 0
    @favorite = Favorite.find :first, :conditions => {:user_id=>current_user.id, :favorable_id => @article.id}
    @favorite.destroy if @favorite

    if request.xhr?
      render :layout => false
    else
      redirect_to article_path(@article)
    end
  end

  protected
  # find correct article according to "id" get params
  def find_article
    @article = Article.find(params[:id])
    @group = @article.group
    if !@group.domain.blank? && request.host != 'localhost' && Rails.env.production?
      select_domain @group
    end
    if @article && logged_in?
      current_user.has_rated? @article
      current_user.has_favorite? @article
      current_user.roles
    end
    @article.score if @article
  rescue ActiveRecord::RecordNotFound
    if @group
      render :template => 'articles/not_found', :status => 404
    else
      show_404
    end
    return false
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
          render :text => score
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
      format.any :js, :json do
        render :json => score
      end
    end
  end
end
