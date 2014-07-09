# -*- encoding : utf-8 -*-
module Article::CommentAspect  
  extend ActiveSupport::Concern
  def has_comments? status='publish'
    comments.by_status(status).count > 0
  end
  def public_comments_count
    comments.public.count
  end    

  included do
    has_many :comments
    has_many :public_comments, -> { where(status: 'publish') }, class_name: "Comment"
  end
end

