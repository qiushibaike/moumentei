# -*- encoding : utf-8 -*-
class Rating < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  scope :pos, lambda{ where{score > 0} }
  scope :neg, lambda{ where{score < 0} } 
  scope :by_period, lambda {|s, e| where(:created_at => s..e)}
  scope :by_group, lambda {|group_id| where(:group_id => group_id).includes(:article)}
  validates_uniqueness_of :article_id, :scope => :user_id
  attr_accessible :article_id, :user_id, :score

  def self.stats_count(options = {})
    group_id, start_date, end_date = options[:group_id], options[:start_date], options[:end_date]
    self.by_group(group_id).by_period("#{start_date.to_s} 00:00", "#{end_date.to_s} 23:59:59").count(:all,:group => "date(ratings.created_at)")
  end
end
