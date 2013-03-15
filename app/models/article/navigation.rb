module Article::Navigation
	module ClassMethods
		
	end
	
	module InstanceMethods
    # find the next entry in specific group
    # and some group may also include subgroup's entries  
    def next_in_group(group=nil)
      group ||= self.group 
      group = Group.find(group) unless group.is_a? Group

      Rails.cache.fetch("article_next/#{group.id}/#{self.id}", :expires_in => 86400) do
        a = Article.find(:first,
          :select => 'articles.id',
          :conditions => ['status = ? AND id > ? AND group_id IN (?)', 
                          'publish',
                          self.id,
                          #group.options[:show_articles_in_children] ? group.full_set.collect(&:id) : group.id
                          group.id
                          ],
          :order => "id",
          :limit => 1)
        a ? a.id : nil
      end
    end

    # find the previous entry in specific group
    # and some group may also include subgroup's entries
    def prev_in_group(group=nil)
      group ||= self.group 
      group = Group.find(group) unless group.is_a? Group
      Rails.cache.fetch("article_prev/#{group.id}/#{self.id}", :expires_in => 86400) do
        a = Article.find(:first,
          :select => 'articles.id',
          :conditions => ['status = ? AND id < ? AND group_id IN (?)', 
                          'publish',
                          self.id,
                          #group.options[:show_articles_in_children] ? group.full_set.collect(&:id) : group.id
        group.id
                          ],
          :order => "id DESC",
          :limit => 1)
        a ? a.id : nil
      end
    end		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end