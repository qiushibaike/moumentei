# Defines named favorites for users that may be applied to objects in a polymorphic fashion.
class <%= class_name %> < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, :polymorphic => true
end
