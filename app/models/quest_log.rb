class QuestLog < ActiveRecord::Base
  belongs_to :user
  def quest
    Quest.find
  end
end
