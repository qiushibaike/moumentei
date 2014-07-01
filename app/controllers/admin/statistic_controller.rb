# -*- encoding : utf-8 -*-
class Admin::StatisticController < Admin::BaseController
  before_filter :login_required, :only => [:index]

  def index

      today = Date.today
      b = today << 1

      res = ActiveRecord::Base.connection.select_all(<<sql)
 select date(created_at), count(*), sum(score) from articles
 where created_at < '#{today}' and created_at > '#{b}'
 group by date(created_at)
sql
      today_articles = res.collect{|c| c["count(*)"].to_i}

      date=res.collect{|c| c["date(created_at)"].to_date.day.to_s}

      today_publish_articles = res.collect{|c| c["sum(score)"].to_i}

      @chart = LazyHighCharts::HighChart.new("articles" ) do |f|
        f.title text: 'Articles'
        f.xAxis(categories: ['article count', 'total score'])
        f.series name: 'article count', yAxis: 0, data: today_articles
        f.series name: 'total score', yAxis: 1, data: today_publish_articles
        f.yAxis [
          {:title => {:text => "article count", :margin => 70} },
          {:title => {:text => "total score"}, :opposite => true},
        ]
        # f.legend(:y => 75, :x => -50)
        f.chart({:defaultSeriesType=>"column"})
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
    @class = params[:object].safe_constantize
    @stats = @class.count :all, :conditions => ['created_at >= ? and created_at <= ?', @start, @end], :group => 'date(created_at)'
  end
end

