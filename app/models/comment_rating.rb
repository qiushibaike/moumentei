class CommentRating < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user
  named_scope :pos, :conditions => {:score => 1}
  named_scope :neg, :conditions => {:score => -1}  
end
