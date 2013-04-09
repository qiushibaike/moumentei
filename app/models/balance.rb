# -*- encoding : utf-8 -*-
class Balance < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
end
