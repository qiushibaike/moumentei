# -*- encoding : utf-8 -*-
class Message < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => 'owner_id'
  belongs_to :sender, :class_name => "User", :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'

  scope :unread, :conditions =>{:read => false}

  validates_length_of :content, :minimum => 1, :allow_nil=>false, :allow_blank=>false

end
