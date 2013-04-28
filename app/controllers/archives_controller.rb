# -*- encoding : utf-8 -*-
class ArchivesController < ApplicationController
  after_filter :store_location, :except => [:index, :show]
  super_caches_page :index, :show
  def index
    @start_year = @first.year
    @end_year = @last.year
  end
  DATE_REGEXP = /\A(\d{4})-?(\d{1,2})?-?(\d{1,2})?\z/.freeze
  def show
    @date = params[:id]
    
    @date.strip!
    @date.chomp!
    match = DATE_REGEXP.match(@date)
    return render :text => '无效的日期', :status => 404 unless match
    match = match.to_a.collect{|i| i && i.to_i}
    _, @year, @month, @day = match
    @now = Time.now
    @current_year = @now.year
    @current_month = @now.month
    @current_day = @now.day
    if !@month and !@day
      year
    elsif !@day
      month
    else
      day
    end
  end
  protected
  def year
    if @year < @start_year or @year > @end_year
      return show_404
    end
    render :action => 'year'
  end

  def month
    @start_day = Date.civil(@year, @month, 1)
    @end_day = (@start_day >> 1) - 1
    @articles = @group.public_articles.by_period(@start_day, @end_day).hottest.paginate :page => params[:page], :per_page => per_page
    @content_for_title = "#{@year}-#{@month}"
    @cache_subject = @articles
    render :action => 'month'
  rescue ArgumentError
    return show_error "无效的日期 #{params[:year]}-#{params[:month]}"
  end

  def day
    @start_day = Date.civil(@year, @month, 1)
    @end_day = (@start_day >> 1) - 1
    @date = Date.civil(@year, @month, @day)
    @articles = @group.public_articles.by_period(@date, @date+1).hottest.paginate :page => params[:page], :per_page => per_page
    @content_for_title = @date.strftime("%Y-%m-%d")
    @cache_subject = @articles
    render :action => 'day' if stale? :last_modified => @date.to_time.utc, :public => true, :etag => [@article, request.format]
  rescue ArgumentError
    return show_error "无效的日期 #{params[:year]}-#{params[:month]}-#{params[:day]}"
  end

  before_filter :find_group
  protected
  def find_border
    @first = @group.public_articles.find(:first, :conditions => 'created_at is not null', :order => 'id asc', :select => 'articles.created_at')
    @last = @group.public_articles.find(:first, :conditions => 'created_at is not null', :order => 'id desc', :select => 'articles.created_at')
    if @first.blank? or @last.blank?
      return show_404('存档')
    end
    @first = @first.created_at.to_date
    @last = @last.created_at.to_date
  end
  
  def per_page
    pp = @group.inherited_option(:per_page)
    pp = 20 if pp.blank?
    pp
  end
  before_filter :find_border
end
