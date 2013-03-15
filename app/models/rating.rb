# -*- coding: utf-8 -*-
class Rating < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  named_scope :pos, :conditions => 'ratings.score > 0'
  named_scope :neg, :conditions => 'ratings.score < 0'
  #validate_uniqueness_of :user_id
  named_scope :by_period, lambda {|s, e| {:conditions => ['ratings.created_at >= ? and ratings.created_at < ?', s, e]}}
  named_scope :by_group, lambda {|group_id| {:conditions => [ "articles.group_id = ?", group_id], :joins => [:article]}}

  def self.stats_count(options = {})
    group_id, start_date, end_date = options[:group_id], options[:start_date], options[:end_date]
    self.by_group(group_id).by_period("#{start_date.to_s} 00:00", "#{end_date.to_s} 23:59:59").count(:all,:group => "date(ratings.created_at)")
  end

end
