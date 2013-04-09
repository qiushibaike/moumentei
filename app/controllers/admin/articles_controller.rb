# -*- encoding : utf-8 -*-
class Admin::ArticlesController < Admin::BaseController
  #before_filter :admin_required, :except =>[:secret_question, :answer_secret, :remove_secret_cmt ]
  #before_filter :doctor_required, :only  => [:secret_question, :answer_secret, :remove_secret_cmt ]
  cache_sweeper :article_sweeper, :only => [:set_status, :batch_set_status, :move]

  def index
    params[:status] = 'pending' if not params[:status]
    @status = params[:status]
    cond = {}
    cond[:status] = @status unless @status == 'all'
    cond[:id] = params[:id] if params[:id]

    if params[:group_id]
      @group = Group.find(params[:group_id])
      cond[:group_id] = @group.id #@group.self_and_descendants.collect{|i|i.id}
    elsif params[:user_id]
      cond.delete(:status)
      @user = User.find params[:user_id]
      cond[:user_id] = params[:user_id]
    end

    @statuses = Article::STATUSES
    @title_name = {'private' => "重审已删除的", 'pending' => "审查新发表的", 'publish' => "重审已通过的"}[@status]

		if params[:status] == 'pending'
		  params[:order_column] ||= 'created_at'
      params[:order] ||= 'asc'
		else
		  params[:order_column] ||= 'created_at'
		  params[:order] ||= 'desc'
		end

		@articles = Article.paginate :page => params[:page], :conditions => cond, :order => "#{params[:order_column]} #{params[:order]}"
    if params[:id] and @articles.size > 0
      @group = @articles[0].group
    end
  end

  def new
    @article = Article.new  :group_id => params[:group_id]
    @article.status = 'publish'
    @article.user_id = current_user.id
  end

  def create
    unless params[:article][:user_id].to_s =~ /\d+/
      user = User.find_by_login params[:article][:user_id]
      if user
        params[:article][:user_id] = user.id
      else
        params[:article].delete(:user_id)
      end
    end    
    
    @article = Article.new params[:article]
    
    %w(status user_id pos_score neg_score).each do |field|
      @article.send "#{field}=", params[:article][field] unless params[:article][field].blank?
    end
    
    if @article.save
      flash[:success] = 'article created'
      redirect_to [:edit, :admin, @article]
    else
      render :action => :new
    end
  end

  def edit
    find_article
  end

  def update
    find_article
    unless params[:article][:user_id].to_s =~ /\d+/
      user = User.find_by_login params[:article][:user_id]
      if user
        params[:article][:user_id] = user.id
      else
        params[:article].delete(:user_id)
      end
    end
    @article.attributes= params[:article]
    logger.debug params[:article].inspect
    %w(status user_id pos_score neg_score).each do |field|
      logger.debug params[:article][field] 
      @article.send "#{field}=", params[:article][field] unless params[:article][field].blank?
    end
    
    if @article.save
      flash[:notice] = "#{@article.id} updated"
    end
    redirect_to :action => 'edit'
  end

  def comments
    @article = Article.find(params[:article_id]||params[:id])
    if @article.comments
      render :layout => false
    else
      render :nothing => true
    end
  end

  def tickets
    @article = Article.find params[:id]
    @tickets = @article.tickets.find(:all, :include => {:user => :weight})
    @score = @tickets.inject 0.0 do |s, t|
      tt = t.ticket_type
      u = t.user
      if u and tt
        w = tt.weight
        if w > 0
          s + w * u.weight.pos_weight
        else
          s + w * u.weight.neg_weight
        end
      else
        s
      end
    end
    #ender :partial => 'ticket', :collection => @article.tickets.find(:all, :include => 'user')
    render :layout => false
  end

  def set_status
    @article = Article.find params[:id]
    orig_status = @article.status
    @article.status = params[:status]
    #@article.title = @article.id.to_s if @article.title.nil? and @article.status == 'publish'
    @article.save!
    AuditLogger.log current_user, 'set article', @article.id, 'status from', orig_status, 'to', params[:status]
    TicketWorker.async_judge(:article_id => @article.id, :approval => (@article.status == 'publish'), :reason => '')
    if request.xhr?
      render :nothing => true
    else
      redirect_to :back
    end
  end

  def batch_set_status
    if params[:id]
      Article.find(params[:id]).each do |article|
        orig_status = article.status
        article.status = params[:status]
        article.save!
        AuditLogger.log current_user, 'set article', article.id, 'status from', orig_status, 'to', params[:status]
        TicketWorker.async_judge(:article_id => article.id, :approval => true)
      end
    end
    if params[:delete_else]
      Article.find(params[:delete_else].split(/,/).collect{|i| i.to_i}).each do |a|
        orig_status = a.status
        a.status = 'private'
        a.save!
        AuditLogger.log current_user, 'set article', a.id, 'status from', orig_status, 'to private'
        TicketWorker.async_judge(:article_id => a.id, :approval =>  false)
      end
    end
    redirect_to :back
  end

  def move
    group = Group.find_by_id params[:group_id]
    return redirect_to :back unless group
    params[:id] = [params[:id]] unless params[:id].is_a? Array
    params[:id].each do |i|
      @article = Article.find i
      original_group = @article.group
      @article.move_to group
      AuditLogger.log current_user, <<log
move \##{@article.id} from #{original_group.id} #{original_group.name} to #{group.id} #{group.name}
log

      @article.anonymous = true if group.force_anonymous?
      Comment.connection.execute "UPDATE comments SET anonymous = true WHERE article_id=#{@article.id}" if group.force_comments_anonymous?
    end
    redirect_to :back
  end
  def track
   Sinatrack.sinapost(params[:id])
  end
  protected
  def find_article
    @article = Article.find params[:id]
  end
end
