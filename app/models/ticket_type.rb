class TicketType < ActiveRecord::Base
  def to_s
    "#{name} #{weight}"
  end
end
