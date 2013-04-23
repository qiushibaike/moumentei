# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-

class Group < ActiveRecord::Base
  acts_as_nested_set
  has_many :articles
  has_many :public_articles, :class_name => 'Article', :conditions => {:status => 'publish'}
  has_many :pages
  serialize :options, Hash
#  has_and_belongs_to_many :moderators, :class_name => 'User', :dependant => :nullify
  validates_format_of :domain, :with => /(\w+\.)+\w+/, :message => "mael format",
    :allow_nil => true,
    :allow_blank => true
  attr_accessible :options, :domain, :name, :description, :parent_id, :alias
  def after_initialize
    self.options ||= {}
  end

  def force_anonymous?
    options[:force_anonymous]
  end

  def force_comments_anonymous?
    options[:force_comments_anonymous]
  end

  def only_member_can_post?
    only_member_can_view? || options[:only_member_can_post]
  end

  def only_member_can_reply?
    only_member_can_view? || options[:only_member_can_reply]
  end

  def only_member_can_view?
    options[:only_member_can_view]
  end

  def articles_need_approval?
    options[:articles_need_approval]
  end
  def comments_need_approval?
    options[:comments_need_approval]
  end

  def encryption?
    options[:encryption]
  end
  
  def self_and_children_ids
    options[:show_articles_in_children] ?
        full_set.collect{|i|i.id} : [id]
  end
  
  def names
    self_and_ancestors.collect{|c|c.name}
  end

  def count_articles_with_children
    Article.count :conditions => {:group_id => all_children.collect{|i|i.id} + [id]}
  end

  def count_by_year(year)
    connection.select_value(<<SQL).to_i
    SELECT `count` FROM year_#{id} WHERE
      `year`=#{year.to_i}
SQL
  end

  def count_by_month(year, month)
    connection.select_value(<<SQL).to_i
    SELECT `count` FROM month_#{id} WHERE
      `year`=#{year.to_i} AND
      `month`=#{month.to_i}
SQL
  end

  def count_by_day(year, month, day)
    connection.select_value(<<SQL).to_i
    SELECT `count` FROM day_#{id} WHERE
      `year`=#{year.to_i} AND
      `month`=#{month.to_i} AND
      `day` =#{day.to_i}
SQL
  end

  def count_by_date(date)
    count_by_day(date.year, date.month, date.day)
  end

  def self.update_summary_table
#    date = Date.new
    now = Time.now
    end_time = Time.local(now.year, now.month, now.day, now.hour)
    start_time = end_time - 3600
    
    self.all.each do |g|
      updated=connection.select_value(<<sql).to_i
      select count(*) from articles where group_id=#{g.id} and status='publish'
        and created_at >= '#{start_time.strftime('%Y-%m-%d %H:%M:%S')}' 
        and created_at < '#{end_time.strftime('%Y-%m-%d %H:%M:%S')}'
sql
      [
"update `year_#{g.id}` set `count`=`count`+#{updated} where `year`=#{start_time.year}",
"update `month_#{g.id}` set `count`=`count`+#{updated} where `year` = #{start_time.year}
  and `month` = #{start_time.month}",
"update `day_#{g.id}` set `count`=`count`+#{updated} where `year` = #{start_time.year}
and `month` =  #{start_time.month} and `day` =  #{start_time.day}"
      ].each { |sql| connection.execute sql}

sql
    end
  end
  
  def inherited attr
    attr = attr.to_sym
    Rails.cache.fetch("Group#{self.id}.I.#{attr}") do
      v = nil
      ([self] + ancestors.reverse).each do |x|
        break v if v = x.send(attr)
      end
      v
    end
  end
  
  after_save do |group|
    group.changed.each do |attr|
      Rails.cache.delete("Group#{group.id}.I.#{attr}")
    end
  end
  
  def inherited_option attr
    attr = attr.to_sym
    Rails.cache.fetch("Group#{self.id}.O.#{attr}") do
      o = nil
      ([self] + ancestors.reverse).each do |x|
        break o = x.options[attr] if x.options && x.options.include?(attr)
      end
      o
    end
  end
  
  before_save do |group|
    group.options_was.each_key do |attr|
      Rails.cache.delete("Group#{group.id}.O.#{attr}")
    end if group.options_was.is_a?(Hash)
  end  

#  def after_save
#    self_and_children.each do |g|
#      Rails.cache.delete("Group#{g.id}.O.#{attr}")
#    end
#  end

  def self.create_summary_table(id)
    connection.execute <<SQL
    
CREATE TABLE IF NOT EXISTS `day_#{id}` (
  `year` smallint(6) NOT NULL,
  `month` tinyint(4) NOT NULL,
  `day` tinyint(4) NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`year`,`month`,`day`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SQL
#    connection.execute <<SQL
#CREATE TABLE IF NOT EXISTS `month_#{id}` (
#  `year` int(11) NOT NULL,
#  `month` int(11) NOT NULL,
#  `count` int(11) NOT NULL,
#  PRIMARY KEY (`year`,`month`)
#) ENGINE=MyISAM DEFAULT CHARSET=latin1;
#SQL
#    connection.execute <<SQL
#CREATE TABLE IF NOT EXISTS `year_#{id}` (
#  `year` smallint(11) NOT NULL,
#  `count` int(11) NOT NULL,
#  PRIMARY KEY (`year`)
#) ENGINE=MyISAM DEFAULT CHARSET=latin1;
#SQL
  end

  before_save :clean_options
  def clean_options
    return unless options.is_a?(Hash)
    options.each do |k,v|
      if v.is_a?(String)
        v = v.downcase
        if v == 'true' or v == 'yes'
          options[k] = true
        elsif v == 'false' or v == 'no'
          options[k] = false
        end
      end
    end
  end
end
