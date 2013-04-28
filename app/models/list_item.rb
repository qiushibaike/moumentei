# -*- encoding : utf-8 -*-
class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :article 
  acts_as_list :scope => :list
end
