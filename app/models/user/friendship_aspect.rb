# -*- encoding : utf-8 -*-
class User
module FriendshipAspect
  def self.included(base)
    base.has_and_belongs_to_many :friends,
      :join_table => 'friendships',
      :foreign_key => 'user_id',
      :association_foreign_key => 'friend_id',
      :uniq => true,
      :class_name => 'User',
      :select => 'users.*'
    base.has_and_belongs_to_many :followers,
      :join_table => 'friendships',
      :foreign_key => 'friend_id',
      :association_foreign_key => 'user_id',
      :uniq => true,
      :class_name => 'User',
      :select => 'users.*'
#  has_many :friendships
#  has_many :friends, :through => :friendships, :source => :user, :foreign_key => 'user_id'
#  has_many :followers, :through => :friendships, :source => :user, :foreign_key => 'friend_id'
  end

  def follow(another_user)
    Friendship.create :user_id => self.id, :friend_id => another_user.id
#    Notification.create :user_id => another_user.id, :type => 'Follow', :content => nil
  rescue ActiveRecord::StatementInvalid => e
    raise e unless e.message.index('Duplicate')
  end

  def unfollow(another_user)
    Friendship.delete_all :user_id => self.id, :friend_id => another_user.id
  end

  def following?(another_user)
    Friendship.find :first, :conditions => {:user_id => self.id, :friend_id => another_user.id}
  end
end
end
