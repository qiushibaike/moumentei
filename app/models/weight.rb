# -*- encoding : utf-8 -*-
# caching the user-related parameters in folks approval 
class Weight < ActiveRecord::Base
  belongs_to :user
  
  def after_initialize
    self.pos ||= user.tickets.count :conditions => {:ticket_type_id => 1}
    self.neg ||= user.tickets.count :conditions => "ticket_type_id > 1 and ticket_type_id is not null"
    self.pos_correct ||= user.tickets.count :conditions => {:correct => true, :ticket_type_id=>1}
    self.neg_correct ||= user.tickets.count :conditions => "ticket_type_id > 1 and ticket_type_id is not null and correct = 1"
    self.correct ||= pos_correct + neg_correct
  end

  def update_all
    self.pos = user.tickets.count :conditions => {:ticket_type_id => 1}
    self.neg = user.tickets.count :conditions => "ticket_type_id > 1 and ticket_type_id is not null"
    self.pos_correct = user.tickets.count :conditions => {:correct => true, :ticket_type_id=>1}
    self.neg_correct = user.tickets.count :conditions => "ticket_type_id > 1 and ticket_type_id is not null and correct = 1"
    self.correct = pos_correct + neg_correct
    save!
  end
#  MaxWeight = 5
#  MinWeight = 0.05
  
  def total
    pos + neg
  end
  
  def correct
    pos_correct + neg_correct
  end
  
  def pos_correct_rate
    pos_correct.to_f / pos.to_f
  end
  
  def pos_correct_weight
    p = pos_correct_rate
    if p <= 0.1
      0.01
    elsif p <= 0.2
      0.1
    elsif p <= 0.3
      0.4
    elsif p <= 0.4
      0.6
    elsif p <= 0.5
      0.9
    else
      1
    end
  end
  
  def neg_correct_rate
    neg_correct.to_f / neg
  end
  
  def neg_correct_weight
    p = neg_correct_rate
    if p <= 0.1
      0.01
    elsif p <= 0.2
      0.2
    elsif p <= 0.3
      0.5
    elsif p <= 0.4
      0.7
    elsif p <= 0.5
      0.9
    else
      1
    end    
  end

  def correct_rate
    correct.to_f / total
  end
  def correct_weight
    pos_correct_weight.to_f * neg_correct_weight.to_f * 1.3
  end
  
  def adjust_weight
    a = adjust || 1
    ((Math.atan(total/50)+0.5)*0.5) * a
  end
  
  def pos_weight
    total > 50 ? (1/avg_ratio) * Math.atan(ratio) * adjust_weight : 0.01
  end

  def neg_weight
    total > 50 ? ((1/avg_ratio)*(3*Math.atan(avg_ratio)) - (1/avg_ratio) * Math.atan(ratio)) * 0.5 * adjust_weight : 0.01
  end

  def ratio
    pos > 0 ? neg.to_f/pos : 0
  end
  
  def avg_ratio
    @avg_ratio ||= self.class.avg_ratio
  end

  def self.avg_ratio
    Rails.cache.fetch('avgratio', :expires_in => 1.hour) do
      connection.select_value("SELECT AVG(neg/pos) FROM #{table_name}").to_f
    end
  end
end
