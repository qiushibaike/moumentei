# -*- encoding : utf-8 -*-
class Report < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :operator, :class_name => 'User'
  serialize :info

  def after_initialize
    self.info ||= []
  end

  def include?(user)
    user = user.id unless user.is_a?(Fixnum)
    info.each do |i|
      return true if i[:user_id] == user
    end
    return false
  end
  
  def self.find_by_target(target)
    find :first, :conditions => {:target_type => target.class.name, :target_id => target.id}
  end
  
  before_save {|r| r.report_times = r.info.size}
end
