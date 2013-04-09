# -*- encoding : utf-8 -*-
class CodeLog < ActiveRecord::Base
  def self.ensure_only(user)
    CodeLog.find_by_user_id_and_date(user.id, Date.today)
   end
end
