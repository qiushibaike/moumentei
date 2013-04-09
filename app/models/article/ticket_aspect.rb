# -*- encoding : utf-8 -*-
module Article::TicketAspect
  def self.included(base)
    base.has_many :tickets
  end
end
