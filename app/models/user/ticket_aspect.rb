# -*- encoding : utf-8 -*-
module User::TicketAspect
  module ClassMethods
    
  end

  module InstanceMethods


    def correct_rate
      c  = tickets.count :conditions => {:correct => true}
      ic = tickets.count :conditions => {:correct => false}
      t = c+ic
      if t >= 1
        c * 100 / t
      else
        0
      end
    rescue
      0
    end

    def correct_rate_coefficient
      c  = tickets.count :conditions => {:correct => true}
      return 0 if c < 100
      cr = correct_rate
      return 0 if cr < 60
      
      return 0.0475*cr-2.75
    end

  end

  def self.included(receiver)
    receiver.class_eval do
      has_many :tickets
      has_one :weight
      alias_fallback :weight, :create_weight

      alias ensure_weight weight
      extend         ClassMethods
      include InstanceMethods
    end
  end
end
