# -*- encoding : utf-8 -*-
class Transaction < ActiveRecord::Base
  belongs_to :balance
  
  def new_transaction(amount,reason)
    self.amount=amount
    self.reason=reason
    self.save!
  end
  
end
