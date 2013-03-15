# -*- coding: utf-8 -*-
# This model stores the global configuration of the website
class Setting < ActiveRecord::Base
  serialize :value
  class << self
    attr_accessor :replacelist_pattern, :blacklist_pattern
    def [] index
      index = index.to_s
      Rails.cache.fetch("Setting.#{index}") do
        record = find_by_key index
        record.value if record
      end
    end
   
    def []= index, value
      find_or_create_by_key(:key => index).update_attribute(:value, value)
      Rails.cache.write("Setting.#{index}", value)
    end
    
    def replacelist_pattern
      @replacelist_pattern ||= Regexp.union(*Setting.replacelist.keys) if Setting.replacelist
    end

    def blacklist_pattern
      @blacklist_pattern ||= Regexp.union(*Setting.blacklist) if Setting.blacklist
    end
    
    def method_missing(selector, *args, &block)
      if selector.to_s =~ /(\w+)=$/
        self[$1]=args[0]
      elsif args.size == 0
        self[selector]
      else
        super
      end
    end
  end

  after_save :clear_pattern_cache
  protected
  def clear_pattern_cache
    self.class.replacelist_pattern = nil if self.key == 'replacelist'
    self.class.blacklist_pattern = nil if self.key == 'blacklist'
  end
end
