# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class Users::ArticlesController < ArticlesController
  #layout 'users'
  theme nil
  #skip_before_filter :super_caches_page
  
  def index   
    if params[:user_id]
      @user = User.find params[:user_id]
      return show_404 if @user.suspended? or @user.deleted?
      scope = @user.articles.signed
    end

    if params[:group_id]
      @group = Group.find_by_alias! params[:group_id]
      return render :text => '', :status => :not_found unless @group
      raise User::NotAuthorized if @group and @group.private and (not logged_in? or !current_user.is_member_of?(@group))
      return render :template => "/groups/pending" if @group.status == "pending"

      scope = @group.public_articles
    end

    scope = scope.public.created_at_lte(Time.now)

    params[:limit] ||= 'day' if params[:order] == 'hottest'

    if i = KEYS.index(params[:limit])
      params[:order] = 'hottest'
      @limit = params[:limit]
      @next_limit = KEYS[i+1]
      scope = scope.ascend_by_score
      scope = scope.created_at_gte(DateRanges[@limit].ago) if @limit != 'all'
    else
      params[:order] = 'latest'
      scope = scope.descend_by_created_at
    end
    @articles = scope.paginate :page => params[:page]
    response.headers['Cache-Control'] = 'private, no-cache, no-store'
    respond_to do |format|
      format.any(:html, :mobile){
        
      }
      format.json do
        render :json => {
          :articles => @articles,
          :num_pages => @articles.num_pages
        }
      end
      format.xml {
        render :text => '<?xml version="1.0" encoding="UTF-8"?><rss></rss>', :status => :not_found if @articles.empty?
      }
      format.atom
    end
  end
end
