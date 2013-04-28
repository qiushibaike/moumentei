# -*- encoding : utf-8 -*-
class CommentRating < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user
  scope :pos, :conditions => {:score => 1}
  scope :neg, :conditions => {:score => -1}  
end
