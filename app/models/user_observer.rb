# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserNotifier.delay.deliver_signup_notification(user)
  end

  def after_save(user)
    UserNotifier.delay.deliver_activation(user) if user.recently_activated?
  end
end
