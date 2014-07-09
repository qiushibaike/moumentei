# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class GroupsController < ApplicationController
  before_filter :find_group, except: [:index]
  after_filter :store_location, only: [:index, :show, :latest, :hottest]
  theme :select_theme

  decorates_assigned :groups, :articles
  #super_caches_page :show, :latest, :hottest, :latest_replied, :most_replied, :pictures, :pending
  # before_filter :date_range_detect, only: [:hottest, :hottestpage, :most_replied]

  def index
    @groups = Group.roots
    if request.format.html?
      if Setting.default_group
        find_group
        return show
      end
    end
    respond_with groups
  end

  # test
  def show
    if request.format.html?
      frontpage = @group.inherited_option(:frontpage)
      if frontpage.blank? or frontpage == 'latest'
        params[:action] = 'latest'
        latest
      elsif frontpage == 'recent_hot'
        redirect_to [:recent_hot, @group, :articles]
      else
        params[:action] = 'hottest'
        params[:limit] = frontpage
        date_range_detect
        hottest
      end
    else
      respond_with group
    end
  end
  #
  # def search
  #   term = params[:term] || ""
  #   term.strip!
  #   if term.size > 1
  #     if term =~ /^#?(\d+)$/
  #       searchid=$1
  #       @article=Article.find_by_id(searchid.to_i)
  #       respond_to  do |format|
  #         format.html{
  #           return redirect_to article_path(@article) if @article
  #         }
  #         format.any :js, :json  do
  #           return render json: {
  #             articles: @article,
  #             total_pages: (1 if @article) }
  #         end
  #       end
  #     end
  #     @articles = Article.search(term,conditions: {group_status: "#{@group.id}publish"},
  #       page: params[:page])
  #   else
  #     term="qwertyuiop"
  #     flash[:notice]="请输入点什么东西吧"
  #     @articles = Article.search(term,conditions: {group_status: "#{@group.id}publish"},
  #       page: params[:page])
  #   end
  #   generic_response(:archives)
  # end

  # def recent_hot
  #   @articles = @group.public_articles.recent_hot(params[:page])
  #   generic_response(:archives)
  # end
  #
  # # test
  # def hottest
  #   per_page = @group.inherited_option(:per_page)
  #   per_page = 20 if per_page.blank?
  #   g = @group.options[:show_articles_in_children] ? @group.self_and_descendants.collect{|i|i.id} : [@group.id]
  #   @articles = Article.hottest.public.published_after(@date).by_group(g).paginate page: params[:page], per_page: per_page, include: :user
  #
  #   if not @articles || @articles.size == 0 && params[:limit] != 'all'
  #     return redirect_to(group_hottest_path(@group, limit: keys[keys.index(params[:limit])+1]))
  #   end
  #
  #   if  @articles &&
  #       @articles.size == 0 &&
  #       @articles.total_pages > 0 &&
  #       @articles.total_pages < @articles.current_page
  #     params[:page] = @articles.total_pages
  #     return redirect_to( params)
  #   end
  #   generic_response(:hottest)
  # end
  #
  # # latest
  def latest
    redirect_to [:latest, @group, :articles]
    # g =  @group.options[:show_articles_in_children] ?
    #   @group.self_and_descendants.collect(&:id) :[@group.id]
    # per_page = @group.inherited_option(:per_page)
    # per_page = 20 if per_page.blank?
    #
    # @articles = Article.by_group(g).public.paginate page: params[:page], per_page: per_page, order: %(published_at #{params[:order] == 'asc' ? 'ASC' : 'DESC'}), include: :user
    #
    # if @articles.size == 0 &&
    #     @articles.total_pages > 0 &&
    #     @articles.total_pages < @articles.current_page
    #   params[:page] = @articles.total_pages
    #   redirect_to(params)
    # else
    #   @articles = ArticleDecorator.decorate_collection(@articles)
    #   generic_response(:archives)
    # end
  end

  def recent_hot
    redirect_to [:recent_hot, @group, :articles]
  end

  def hottest
    redirect_to controller: :articles, action: :index, group_id: @group, hottest: params[:hottest]
  end

  # def pending
  #   @expires_in = 1.minutes
  #   g = @group.id
  #   @articles = @group.articles.pending.paginate page: params[:page], order: 'articles.created_at desc', include: :user
  #   generic_response(:archives)
  # end
  # def latest_replied
  #   @articles = @group.public_articles.paginate page: params[:page], order: 'updated_at desc'
  #   generic_response(:archives)
  # end
  #
  # def most_replied
  #   g = @group.options[:show_articles_in_children] ? @group.self_and_descendants.collect{|i|i.id} : [@group.id]
  #   @articles = Article.paginate_by_most_replied(params[:page], g, @date)
  #
  #   if not @articles || @articles.size == 0 && params[:limit] != 'all'
  #     return redirect_to(
  #       controller: :groups,
  #       action: :most_replied,
  #       id: @group.id,
  #       limit: keys[keys.index(params[:limit])+1])
  #   end
  #   if  @articles &&
  #       @articles.size == 0 &&
  #       @articles.total_pages > 0 &&
  #       @articles.total_pages < @articles.current_page
  #     params[:page] = @articles.total_pages
  #     return redirect_to( params)
  #   end
  #   generic_response
  # end

  # def digest_rss
  #   today = Date.today
  #   #    items = @group.public_articles.find(:all, conditions: ["created_at < ? and created_at >= ?", today, today - 7], order: "id DESC")
  #   #    items_per_day = items.group_by{|p| p.created_at.to_date.jd}
  #   days = (1..10).collect{|i| today - i}
  #   expires_in 1.day
  #   _items = days.collect do |day|
  #     items = Article.hottest_by_date(@group.id, 10, day)
  #     date = day.strftime("%Y年%m月%d日")
  #     hash = {}
  #     #count = @group.public_articles.count(conditions: ["created_at >= ? and created_at < ?", day, day+1])
  #     hash[:title] = "#{date}#{@group.name.mb_chars[0,2]}TOP10"
  #     hash[:pubDate] = day.to_time
  #     items.reject!{|i| i.picture.file? }
  #     if items.size > 0
  #       hash[:link] = archive_url(year: day.year, month: day.month, day: day.day, host: @group.domain)
  #       hash[:description] = ['common/digest', items]
  #       hash[:guid] = archive_url(year: day.year, month: day.month, day: day.day, host: @group.domain)
  #     else
  #       hash[:link] = home_url
  #       hash[:guid] = home_url + ';' + date
  #       hash[:description] = '本日没有帖子'
  #     end
  #     hash
  #   end
  #
  #   render_feed items: _items, title: @group.name, pubDate: today.to_time
  # end

  # # make rss feed for the groups' articles
  # def rss
  #   @items = Article.find(:all,
  #     conditions: {group_id: @group.id},
  #     order: "created_at DESC", limit: 30)
  #   if @items.size == 0
  #     show_404
  #   else
  #     expires_in 1.hour
  #     article = @items.first
  #     if stale?(last_modified: article.created_at.utc, etag: @items)
  #       @items.collect! do |item|
  #         a = item
  #         if a.title
  #           t = a.title
  #         else
  #           t = "\##{a.id} - "
  #           unless a.content.blank?
  #             t << a.content.mb_chars[0,30].gsub(/\r?\n/," ")
  #             t << '...'
  #           end
  #         end
  #         link = @group.domain.blank? ? article_url(a.id) : article_url(a.id, host: @group.domain)
  #         {
  #           title: "#{t}",
  #           link: link,
  #           description: ['common/rss_item', a],
  #           pubDate: a.created_at,
  #           guid: link
  #         }
  #       end
  #       render_feed items: @items, title: @group.name
  #     end
  #   end
  # end
  #
  # def favicon
  #   if @group and
  #     (theme = @group.inherited_option(:theme)) and
  #     File.directory?(theme_path = Theme.path_to_theme(theme))
  #     path = "#{theme_path}/images/favicon.ico"
  #     return render text: 'Not Found', status: 404 unless File.exists?(path)
  #     expires_in 1.day, public: true
  #     if stale?(last_modified: File.mtime(path), public: true)
  #       send_file path,
  #         type: 'image/vnd.microsoft.icon', disposition: 'inline', stream: false
  #     end
  #   else
  #     render text: "Not Found", status: 404
  #   end
  # end
end
