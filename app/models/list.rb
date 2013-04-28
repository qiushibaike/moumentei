# -*- encoding : utf-8 -*-
class List < ActiveRecord::Base
  has_many :items, :class_name => 'ListItem', :order => 'position'
  belongs_to :user
  has_many :articles, :through => :items
end
