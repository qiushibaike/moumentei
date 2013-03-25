# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
# Defines named favorites for users that may be applied to objects in a polymorphic fashion.
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, :polymorphic => true
  self.record_timestamps = false
  attr_accessible :favorable_id, :favorable_type, :user_id
end
