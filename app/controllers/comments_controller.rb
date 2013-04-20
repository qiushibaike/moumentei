# -*- encoding : utf-8 -*-
class CommentsController < InheritedResources::Base
  cache_sweeper :comment_sweeper, :only => [ :create ]
  before_filter :find_article, :except => [:up, :dn], :if => Proc.new {|c| c.params.include?(:article_id)}
  before_filter :find_post, :except => [:up, :dn], :if => Proc.new {|c| c.params.include?(:post_id)}
  #before_filter :oauthenticate, :only => [:create]
  before_filter :login_required, :except => [:index, :show, :count, :create, :up, :dn,:report]
  super_caches_page :index

  # GET /comments
  # GET /comments.xml
  def index
    #expires_in 1.minute, 'max-stale' => 1.day, :public => true
    opt = {}
    opt[:public] = true unless is_mobile_device?
    opt[:last_modified] = @article.updated_at.utc
    opt[:etag] = [@article, @article.public_comments_count, request.format]
    
    if stale?(opt)
      cond = ''
      cond = ['comments.floor > ?', params[:after]] if params[:after]
      if request.xhr?
        @comments = @article.comments.find :all, :conditions => cond,  :order => "id asc", :include => :user
      elsif @article
        @comments = @article.comments.paginate :conditions => cond, :page => params[:page],:order => 'id asc', :include => :user
      end
      respond_to do |format|
        format.html {
          render :layout => false
        }
        format.mobile {
          render :layout => false if request.xhr?
        }
        format.any(:json, :js) do
          json = []
          @comments.each do |c|
            j = c.as_json(
              :except => ( c.anonymous ?
                  ['user_id', 'anonymous', 'ip', 'status'] :
                  ['ip', 'anonymous', 'status']
              ))
            j['user'] = {:login => c.user.login} unless c.anonymous
            json << j
          end
          render :json => json
        end
        format.rss do
          expires_in 1.hour
          @comments.collect! do |item|
            {
              :title       => "#{item.anonymous ? '匿名用户' : item.user.login}发表于#{@group.name.mb_chars[0,2]}\##{@article.id}上的评论",
              :link        => "#{article_url(@article)}\#comment-#{item.id}",
              :pubDate     => item.created_at,
              :guid        => "#{article_url(@article)}\#comment-#{item.id}",
              :description => item.content
            }
          end
          @comments.reverse!
          render_feed :items => @comments,
            :title => "#{@group.name.mb_chars[0,2]}\##{@article.id}中的评论",
            :pubDate => @article.updated_at
        end
      end
    end
  end

  def show
    @comment = @article.comments.public.find_by_floor(params[:id])
    return show_404 unless @comment
    @cache_subject = @comment
    respond_to do |format|
      format.html{
        render :partial => @comment
      }
    end
  end

  def count
    fresh_when :etag => @article, :last_modified => @article.updated_at.utc, :public => true
    respond_to do |format|
      format.html {
        render :text => @article.comments.count
      }
      format.json{
        render :json => {:count => @article.comments.count}
      }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    return_with_text = Proc.new do |text|
      respond_to do |format|
        format.any(:html, :mobile) {
          if request.xhr?
            render :text => text
          else
            flash[:error] = text
            render :action => 'new'
          end
        }

        format.any(:js, :json){
          render :json => {:error => text}, :status => :unprocessable_entity
        }
      end
      return
    end

    if @article #when creating article's comments
      #    @article = Article.find params[:comment] unless @article
      group = @article.group
      @comment = comment = Comment.new(params[:comment])
      if not logged_in? and params[:user]
        logout_keeping_session!
        user = User.authenticate(params[:user][:login], params[:user][:password])
        if user
          cookies['login'] = {:value => current_user.to_json(:only => [:id, :login, :state]), :expires => 10.minutes.from_now}
          self.current_user= user
        else
          return_with_text["登录失败"]
        end
      end

      if group.only_member_can_reply?
        unless logged_in?
          return_with_text.call('必须登录才能回帖')
        else
          if current_user.state != 'active'
            return_with_text.call("您尚未激活帐号，请先激活")
          end
        end
      end

      if @article.comment_status == 'closed'
        return_with_text.call("评论已被关闭")
      end

      comment.content.strip!
      hsh = Digest::MD5.hexdigest comment.content
      return_with_text.call('请不要重复提交') if hsh == session[:last_content]
      session[:last_content] = hsh
      return_with_text.call('内容不能为空') if comment.content.size == 0
      comment.parent_id = nil if comment.parent_id.blank?
      comment.anonymous ||= false

      if logged_in?
        current_user.has_favorite @article
        comment.user_id = current_user.id
        comment.anonymous = true if group.force_comments_anonymous?
      else
        comment.anonymous = true
      end

      comment.status = group.comments_need_approval? ? 'pending' : 'publish'
      @article.comments << comment
      respond_to do |format|
        format.any(:html, :mobile) {
          if request.xhr? || params[:asset]
            if comment.status == 'publish'
              render :partial => 'comments/comment', :object => comment#, :locals => {:comment_counter => @article.public_comments_count}
            else
              render :text => comment.public? ? '评论成功' : "您的评论已提交，请等待审核"
            end
          else
            redirect_to article_path(comment.article_id)
          end
        }
        format.json {
          render :json => comment, :status => :created
        }
      end

      if params[:vote]
        unless current_user.has_rated?(@article)
          score = params[:vote].to_i
          score = 1 if score > 1
          score = -1 if score < -1
          current_user.rate(@article, score)
        end
      end
    end
  end

  def up
    vote 1
  end
  #vote down
  def dn
    vote -1
  end


  protected
  def vote score
    opt = {:comment_id => params[:id], :score => score }
    opt[:user_id] = current_user.id if logged_in?
    CommentWorker.async_vote opt
    render :nothing => true
  end

  def find_post
    @post = Post.find params[:post_id]
    @article = @post
  end

  def find_article
    #find_group

    if params[:article_id]
      @article = Article.find(params[:article_id])
      @group = @article.group
      if request.host != 'localhost' and Rails.env.production?
        select_domain @group
        #if not @group.is_or_is_ancestor_of?(@article.group)
        #  render :template => 'articles/not_found', :status => 404
        #  return false
        #end
      end
    end
    #end if params[:article_id]
    #    if @article && logged_in?
    #      current_user.has_rated? @article
    #      current_user.has_favorite? @article
    #      current_user.roles
    #    end
    #    @article.score if @article

  rescue ActiveRecord::RecordNotFound
    if @group
      render :template => 'articles/not_found', :status => 404
    else
      show_404
    end
  end
end
