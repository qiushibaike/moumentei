# -*- encoding : utf-8 -*-
class Admin::StatisticController < Admin::BaseController
  before_filter :login_required, :only => [:index]
  def index
    respond_to do |wants|
      wants.html {
        @graph = open_flash_chart_object( 640, 240, url_for( :action => 'index', :format => :json ) )
        
      }
      wants.json {
        today = Date.today
        b = today << 1
        today_articles = ActiveRecord::Base.connection.select_all(<<sql).collect{|c| c["count(*)"].to_i}
   select date(created_at),count(*) from articles
   where created_at < '#{today}' and created_at > '#{b}' and group_id=2
   group by date(created_at)
sql
        date=ActiveRecord::Base.connection.select_all(<<sql).collect{|c| c["date(created_at)"].to_date.day.to_s}
   select date(created_at),count(*) from articles
   where created_at < '#{today}' and created_at > '#{b}' and group_id=2
   group by date(created_at)
sql

        today_publish_articles = ActiveRecord::Base.connection.select_all(<<sql).collect{|c| c["count(*)"].to_i}
   select date(created_at),count(*) from scores
   where created_at < '#{today}' and created_at > '#{b}'  and  group_id=2
   group by date(created_at)
sql
        chart = OpenFlashChart.new("articles statistics" )
        y_axis = YAxis.new
        x_axis = XAxis.new
        x_axis.set_labels(date)
        max = today_articles.max || 100
        y_axis.set_range(0, max, max/10)
        chart.y_axis =  y_axis
        chart.x_axis =  x_axis
        today_articlesbar=BarGlass.new({:values => today_articles,:colour=>'#000000',:text=>"articles"})
        today_publish_articlesbar=BarGlass.new({:values => today_publish_articles,:text=>"publish articles"})
        chart<<today_articlesbar
        chart<<today_publish_articlesbar

        render :text => chart, :layout => false
      }
    end
  end
  def  statistics_info

    @statistic=Statistics.find(:first,:condition=>["limit= ? ccand created_at >?","24_hours", 24.hours.ago])
  end

  def stats
    @today = Date.today
    @start = params[:start] ? Date.parse( params[:start]) : (@today << 1)
    @end = params[:end] ? Date.parse(params[:end]) : (@today)
    params[:object]||='User'
    @class = Kernel.const_get(params[:object])
    @stats = @class.count :all, :conditions => ['created_at >= ? and created_at <= ?', @start, @end], :group => 'date(created_at)'
  end
end

