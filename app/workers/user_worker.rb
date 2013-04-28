# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
# coding: utf-8

class UserWorker  < BaseWorker
  def send_notification(options)
    user= User.find options.delete(:user_id)
    user.notifications.create(options)
  end
end

