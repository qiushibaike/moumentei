# -*- encoding : utf-8 -*-
class AnonymousRating < ActiveRecord::Base
  belongs_to :article
  scope :pos, -> { where{score > 0} }
  scope :neg, -> { where{score < 0} }
  scope :by_period, -> (s, e) { where{created_at >= s and created_at < e} }
  scope :by_group, -> (group_id) { where(group_id: group_id) }
  attr_accessible :ip, :score, :article_id

  def ip=(ip)
    self[:ip] = IPUtils.ip2long(ip) unless ip.is_a?(Integer)
  end

  def self.vote(ip, article, score)
    if article.is_a?(Article)
      article_id = article
    else
      article_id = article
      article = Article.find article
    end

    r = article.anonymous_ratings.new ip: ip
    if score > 0
      article.pos += score
      article.score += score
      r.score = score
    elsif score < 0
      article.neg += score
      article.score += score
      r.score = score
    end
    r.save!
    article.calc_alt_score
  rescue ActiveRecord::RecordNotUnique
    false
  end

  def self.has_rated?(ip, article_id)
    ip = IPUtils.ip2long(ip) unless ip.is_a?(Integer)
    case article_id
    when Article
      article_id = article_id.id if article_id.is_a?(Article)
      where(ip: ip, article_id: article_id).exists?
    when Integer
      where(ip: ip, article_id: article_id).exists?
    when Array
      m = {}
      where(ip: ip, article_id: article_id).each do |r|
        m[r.article_id] = r.score
      end
      m
    end
  end

  def self.stats_count(options = {})
    group_id, start_date, end_date = options[:group_id], options[:start_date], options[:end_date]
    self.by_group(group_id).by_period("#{start_date.to_s} 00:00", "#{end_date.to_s} 23:59:59").count(:all,group: "date(anonymous_ratings.created_at)")
  end
end
