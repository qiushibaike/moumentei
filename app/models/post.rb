# -*- encoding : utf-8 -*-
#
#
class Post < ActiveRecord::Base
  has_many  :comments
  belongs_to :user
  belongs_to :parent, :class_name => 'Post'
  has_many :replies, :class_name => 'Post', :foreign_key => 'parent_id', :conditions => {:reshare => false}
  has_many :children, :class_name => 'Post', :foreign_key => 'parent_id'
  def post_to group_ids, anonymous = false
    group_ids.map do |gid|
      Article.create :group_id => gid, 
                     :content => content,
                     :group_id => gid,
                     :user_id => user_id,
                     :status => 'pending',
                     :anonymous => anonymous
    end
  end
  
  #scope :time
end
