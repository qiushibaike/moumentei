# -*- encoding : utf-8 -*-
module Article::CommentAspect  
  module InstanceMethods
    def has_comments? status='publish'
      comments.by_status(status).count > 0
    end
    def public_comments_count
      comments.public.count
    end    
  end
  
  def self.included(base)
    base.class_eval do 
      has_many :comments
      has_many :public_comments,
               :class_name => "Comment",
               :conditions => {:status => ['publish']}
      include InstanceMethods
    end
  end
end

