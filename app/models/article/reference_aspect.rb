# -*- encoding : utf-8 -*-
module Article::ReferenceAspect  
  module InstanceMethods
    def detect_reference
      self.content.scan(/#(\d+)/) do |m|
        a = Article.find_by_id(m[0])
        if a and not a.reference_ids.include?(self.id)
          a.references << self
        end     
      end unless self.content.blank?
    end    
  end
  
  def self.included(base)
    base.class_eval do 
      has_and_belongs_to_many :references, 
        :class_name => 'Article', 
        :join_table => 'article_references', 
        :foreign_key => 'source', 
        :association_foreign_key => 'referer', 
        :uniq => true
      has_and_belongs_to_many :public_references, 
        :class_name => 'Article', 
        :join_table => 'article_references', 
        :foreign_key => 'source', 
        :association_foreign_key => 'referer', 
        :uniq => true,
        :conditions => {:status => 'publish'}   
      after_create :detect_reference
      include InstanceMethods
    end
  end
end
