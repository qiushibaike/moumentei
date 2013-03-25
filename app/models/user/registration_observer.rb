# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class User::RegistrationObserver < ActiveRecord::Observer
  observe :user
  def after_create(user)
    UserNotifier.signup_notification(user).deliver
  end

  def after_save(user)
    UserNotifier.activation(user).deliver if user.recently_activated?
  end
end
