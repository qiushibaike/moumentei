# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class Rating < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  scope :pos, :conditions => 'ratings.score > 0'
  scope :neg, :conditions => 'ratings.score < 0'
  #validate_uniqueness_of :user_id
  scope :by_period, lambda {|s, e| {:conditions => ['ratings.created_at >= ? and ratings.created_at < ?', s, e]}}
  scope :by_group, lambda {|group_id| {:conditions => [ "articles.group_id = ?", group_id], :joins => [:article]}}
  attr_accessible :article_id, :user_id, :score

  def self.stats_count(options = {})
    group_id, start_date, end_date = options[:group_id], options[:start_date], options[:end_date]
    self.by_group(group_id).by_period("#{start_date.to_s} 00:00", "#{end_date.to_s} 23:59:59").count(:all,:group => "date(ratings.created_at)")
  end

end
