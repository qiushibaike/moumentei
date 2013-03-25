# -*- encoding : utf-8 -*-
class TicketType < ActiveRecord::Base
  def to_s
    "#{name} #{weight}"
  end
end
