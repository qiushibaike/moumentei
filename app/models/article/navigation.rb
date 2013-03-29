# -*- encoding : utf-8 -*-
module Article::Navigation
	module ClassMethods
		
	end
	
	module InstanceMethods
    # find the next entry in specific group
    # and some group may also include subgroup's entries  
    def next_in_group(group=nil)
      group ||= self.group 
      group = Group.find(group) unless group.is_a? Group

      #Rails.cache.fetch("article_next/#{group.id}/#{self.id}", :expires_in => 86400) do
      group.public_articles.where('id > ?', self.id).order('id asc').first
        
      #end
    end

    # find the previous entry in specific group
    # and some group may also include subgroup's entries
    def prev_in_group(group=nil)
      group ||= self.group 
      group = Group.find(group) unless group.is_a? Group
      #Rails.cache.fetch("article_prev/#{group.id}/#{self.id}", :expires_in => 86400) do
      group.public_articles.where('id < ?', id).order('id desc').first
      #  a ? a.id : nil
      #end
    end		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end
