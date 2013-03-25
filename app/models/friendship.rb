# -*- encoding : utf-8 -*-
class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
end
