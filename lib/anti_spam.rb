# -*- encoding : utf-8 -*-
module AntiSpam
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    # options
    # :only => <events>
    # events are before_save, before_create
    def harmonize(*fields)
      return unless Setting.replacelist_pattern
      opt = fields.pop if fields.last.is_a?(Hash)
      opt ||= {}
      opt = {:at => :before_validation}.merge(opt)
      at = opt[:at]
      send at do |record|
        fields.each do |field|
          record[field] = filter_keywords(record[field]) if record.send "#{field}_changed?" and !(record[field].blank?)
          record.status = 'spam' if record.new_record? and Setting.blacklist_pattern and record.content =~ Setting.blacklist_pattern
        end
      end
    end
  end
  def filter_keywords(content)
    content.gsub(Setting.replacelist_pattern) do
      Setting.replacelist[$&] 
    end if Setting.replacelist_pattern
  end  
end
