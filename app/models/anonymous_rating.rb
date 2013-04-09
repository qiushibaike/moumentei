# -*- encoding : utf-8 -*-
class AnonymousRating < ActiveRecord::Base
  belongs_to :article
  scope :pos, :conditions => 'anonymous_ratings.score > 0'
  scope :neg, :conditions => 'anonymous_ratings.score < 0'
  scope :by_period, lambda {|s, e| {:conditions => ['anonymous_ratings.created_at >= ? and anonymous_ratings.created_at < ?', s, e]}}
  scope :by_group, lambda {|group_id| {:conditions => [ "articles.group_id = ?", group_id], :joins => [:article]}}

  def self.vote(ip, article, score)
    ip = ip2long(ip) unless ip.is_a?(Integer)
    
    article_id = article.is_a?(Article) ? article.id : article
    sql = <<sql
      INSERT INTO #{quoted_table_name}
      (`ip`, article_id, score)VALUES(#{ip}, #{article_id}, #{score.to_i})
sql
    begin
      connection.execute sql
      #ScoreWorker.async_rate(article_id, score) 
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /Duplicate/
        logger.info("#{long2ip(ip)} vote #{article_id} duplicated")
      else
        raise e
      end
    end
  end

  def self.has_rated?(ip, article_id)
    ip = ip2long(ip) unless ip.is_a?(Integer)
    case article_id
    when Article
      article_id = article_id.id if article_id.is_a?(Article)
      search(:ip => ip, :article_id => article_id).count > 0
    when Integer
      search(:ip => ip, :article_id => article_id).count > 0
    when Array
      m = {}
      all(:conditions => {:ip => ip, :article_id => article_id}).each do |r|
        m[r.article_id] = r.score
      end
      m
    end
  end

  def self.stats_count(options = {})
    group_id, start_date, end_date = options[:group_id], options[:start_date], options[:end_date]
    self.by_group(group_id).by_period("#{start_date.to_s} 00:00", "#{end_date.to_s} 23:59:59").count(:all,:group => "date(anonymous_ratings.created_at)")
  end

end
